use std::collections::HashMap;
use crate::storage::Entry;

pub struct AskarEntry {
    entry: Entry,
}

impl AskarEntry {
    pub fn new(entry: Entry) -> Self {
        Self { entry }
    }
}

#[uniffi::export]
impl AskarEntry {
    pub fn category(&self) -> String {
        self.entry.category.clone()
    }

    pub fn name(&self) -> String {
        self.entry.name.clone()
    }

    pub fn tags(&self) -> HashMap<String, String> {
        let mut map = HashMap::new();
        for tag in &self.entry.tags {
            map.insert(tag.name().to_string(), tag.value().to_string());
        }
        map
    }

    pub fn value(&self) -> Vec<u8> {
        self.entry.value.to_vec()
    }
}
