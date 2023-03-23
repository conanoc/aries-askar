use std::str::FromStr;
use std::sync::{Arc, RwLock};
use crate::any::AnySession;
use crate::storage::EntryTagSet;
use crate::{
    uffi::{error::ErrorCode, entry::AskarEntry},
    storage::{Entry, EntryOperation, Scan, TagFilter},
};

pub struct AskarSession {
    session: RwLock<AnySession>,
}

impl AskarSession {
    pub fn new(session: AnySession) -> Self {
        Self { session: RwLock::new(session) }
    }
}

#[uniffi::export]
impl AskarSession {
    pub async fn count(
        &self,
        category: String,
        tag_filter: Option<String>,
    ) -> Result<i64, ErrorCode> {
        Ok(self.
            session
            .write()
            .unwrap()
            .count(&category, tag_filter.as_deref().map(TagFilter::from_str).transpose()?)
            .await?)
    }

    pub async fn fetch(
        &self,
        category: String,
        name: String,
        for_update: bool,
    ) -> Result<Option<Arc<AskarEntry>>, ErrorCode> {
        let entry = self
            .session
            .write()
            .unwrap()
            .fetch(&category, &name, for_update)
            .await?;
        Ok(entry.map(|entry| Arc::new(AskarEntry::new(entry))))
    }

    pub async fn fetch_all(
        &self,
        category: String,
        tag_filter: Option<String>,
        limit: Option<i64>,
        for_update: bool,
    ) -> Result<Vec<Arc<AskarEntry>>, ErrorCode> {
        let entries = self
            .session
            .write()
            .unwrap()
            .fetch_all(&category, tag_filter.as_deref().map(TagFilter::from_str).transpose()?, limit, for_update)
            .await?;
        Ok(entries
            .into_iter()
            .map(|entry| Arc::new(AskarEntry::new(entry)))
            .collect())
    }

    pub async fn update(
        &self,
        operation: EntryOperation,
        category: String,
        name: String,
        value: Vec<u8>,
        tags: Option<String>,
        expiry_ms: Option<i64>,
    ) -> Result<(), ErrorCode> {
        let tags = if let Some(tags) = tags {
            Some(
                serde_json::from_str::<EntryTagSet<'static>>(&tags)
                    .map_err(err_map!("Error decoding tags"))?
                    .into_vec(),
            )
        } else {
            None
        };
        self.session
            .write()
            .unwrap()
            .update(operation, &category, &name, Some(&value), tags.as_deref(), expiry_ms)
            .await?;
        Ok(())
    }
}
