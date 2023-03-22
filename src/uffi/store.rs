use std::sync::{Arc, RwLock};
use crate::{
    backend::{
        any::{AnySession, AnyStore},
        ManageBackend,
    },
    uffi::error::ErrorCode,
    protect::{generate_raw_store_key, PassKey, StoreKeyMethod},
    storage::{Entry, EntryOperation, EntryTagSet, Scan, TagFilter},
};

pub struct AskarStore {
    store: RwLock<Option<AnyStore>>,
}

#[uniffi::export]
pub fn askar_generate_raw_store_key(seed: Option<String>) -> Result<String, ErrorCode> {
    let key = generate_raw_store_key(seed.as_ref().map(|s| s.as_bytes()))?;
    Ok(key.to_string())
}

#[uniffi::export]
pub async fn askar_store_provision(
    spec_uri: String,
    key_method: Option<String>,
    pass_key: Option<String>,
    profile: Option<String>,
    recreate: bool,
) -> Result<Arc<AskarStore>, ErrorCode> {
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
    Ok(Arc::new(AskarStore { store: RwLock::new(Some(store)) }))
}

#[uniffi::export]
pub async fn askar_store_open(
    spec_uri: String,
    key_method: Option<String>,
    pass_key: Option<String>,
    profile: Option<String>,
) -> Result<Arc<AskarStore>, ErrorCode> {
    let key_method = match key_method {
        Some(method) => Some(StoreKeyMethod::parse_uri(&method)?),
        None => None
    };
    let pass_key = PassKey::from(pass_key.as_deref()).into_owned();
    let store = spec_uri.open_backend(
        key_method,
        pass_key,
        profile.as_deref(),
    ).await?;
    Ok(Arc::new(AskarStore { store: RwLock::new(Some(store)) }))
}

#[uniffi::export]
pub async fn askar_store_remove(spec_uri: String) -> Result<bool, ErrorCode> {
    let removed = spec_uri.remove_backend().await?;
    Ok(removed)
}

#[uniffi::export]
impl AskarStore {
    pub async fn create_profile(&self, profile: Option<String>) -> Result<String, ErrorCode> {
        let name = self.store.read().unwrap().as_ref().unwrap().create_profile(profile).await?;
        Ok(name)
    }

    pub fn get_profile_name(&self) -> String {
        self.store.read().unwrap().as_ref().unwrap().get_profile_name().to_string()
    }

    pub async fn remove_profile(&self, profile: String) -> Result<bool, ErrorCode> {
        let removed = self.store.read().unwrap().as_ref().unwrap().remove_profile(profile).await?;
        Ok(removed)
    }

    pub async fn rekey(&self, key_method: Option<String>, pass_key: Option<String>) -> Result<(), ErrorCode> {
        let key_method = match key_method {
            Some(method) => StoreKeyMethod::parse_uri(&method)?,
            None => StoreKeyMethod::default()
        };
        let pass_key = PassKey::from(pass_key.as_deref()).into_owned();
        self.store.write().unwrap().as_mut().unwrap().rekey(key_method, pass_key).await?;
        Ok(())
    }

    pub async fn close(&self) -> Result<(), ErrorCode> {
        let store = self.store.write().unwrap().take();
        store.unwrap().close().await?;
        Ok(())
    }

    // scan
}
