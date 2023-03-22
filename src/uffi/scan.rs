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
    pub async fn next(&self) -> Result<Vec<Arc<AskarEntry>>, ErrorCode> {
        let mut scan = self.scan.write().unwrap();
        let entries = scan.fetch_next().await?;
        let entries = entries
            .unwrap_or(vec![])
            .into_iter()
            .map(|entry| Arc::new(AskarEntry::new(entry)))
            .collect();
        Ok(entries)
    }
}
