use std::sync::{Arc, RwLock};
use crate::{
    uffi::{error::ErrorCode, entry::AskarEntry},
    storage::{Entry, Scan},
};

pub struct AskarScan {
    scan: RwLock<Scan<'static, Entry>>,
}

// Not sure if this is safe, but uniffi requires Sync.
unsafe impl<'s, T> Sync for Scan<'s, T> {}

impl AskarScan {
    pub fn new(scan: Scan<'static, Entry>) -> Self {
        Self { scan: RwLock::new(scan) }
    }
}

#[uniffi::export]
impl AskarScan {
    pub async fn next(&self) -> Result<Option<Vec<Arc<AskarEntry>>>, ErrorCode> {
        let mut scan = self.scan.write().unwrap();
        let entries = scan.fetch_next().await?;
        let entries: Vec<Arc<AskarEntry>> = entries
            .unwrap_or(vec![])
            .into_iter()
            .map(|entry| Arc::new(AskarEntry::new(entry)))
            .collect();
        if entries.is_empty() {
            Ok(None)
        } else {
            Ok(Some(entries))
        }
    }

    pub async fn fetch_all(&self) -> Result<Vec<Arc<AskarEntry>>, ErrorCode> {
        let mut scan = self.scan.write().unwrap();
        let mut entries = vec![];
        while let Some(mut batch) = scan.fetch_next().await? {
            entries.append(&mut batch);
        }
        let entries = entries
            .into_iter()
            .map(|entry| Arc::new(AskarEntry::new(entry)))
            .collect();
        Ok(entries)
    }
}
