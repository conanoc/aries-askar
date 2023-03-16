use crate::{
    backend::{
        any::{AnySession, AnyStore},
        ManageBackend,
    },
    uffi::error::ErrorCode,
    protect::{generate_raw_store_key, PassKey, StoreKeyMethod},
    storage::{Entry, EntryOperation, EntryTagSet, Scan, TagFilter},
};

pub struct Store {
    store: AnyStore,
}

impl Store {
    pub fn generate_raw_store_key(seed: Option<String>) -> Result<String, ErrorCode> {
        let key = generate_raw_store_key(seed.as_ref().map(|s| s.as_bytes()))?;
        Ok(key.to_string())
    }

    pub async fn provision(
        spec_uri: String,
        key_method: Option<String>,
        pass_key: Option<String>,
        profile: Option<String>,
        recreate: bool,
    ) -> Result<Store, ErrorCode> {
        let key_method = match key_method {
            Some(method) => StoreKeyMethod::parse_uri(&method)?,
            None => StoreKeyMethod::default()
        };
        let pass_key = PassKey::from(pass_key.as_deref()).into_owned();
        let store = spec_uri.provision_backend(
            key_method,
            pass_key,
            profile.as_deref(),
            recreate,
        ).await?;
        Ok(Store { store })
    }
}
