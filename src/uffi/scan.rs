use std::sync::{Arc, RwLock};
use crate::{
    uffi::{error::ErrorCode, entry::AskarEntry},
    storage::{Entry, Scan},
};

pub struct AskarScan {
    scan: RwLock<Scan<'static, Entry>>,
}

impl AskarScan {
    pub fn new(scan: Scan<Entry>) -> Self {
        Self { scan: RwLock::new(scan) }
    }
}

#[uniffi::export]
impl AskarScan {
    pub async fn next(&self) -> Result<Vec<Arc<AskarEntry>>, ErrorCode> {
        let mut scan = self.scan.write().unwrap();
        let entrys = scan.fetch_next().await?;
        Ok(entrys.into_iter().map(Arc::new(AskarEntry::new)).collect())
    }
}
