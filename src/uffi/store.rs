use std::sync::{Arc, RwLock};
use std::str::FromStr;
use crate::{
    backend::{
        any::AnyStore,
        ManageBackend,
    },
    uffi::{error::ErrorCode, scan::AskarScan},
    protect::{generate_raw_store_key, PassKey, StoreKeyMethod},
    storage::TagFilter,
};

macro_rules! STORE_CLOSED_ERROR {
    () => {
        ErrorCode::Unexpected { message: String::from("Store is already closed") }
    };
}

pub struct AskarStore {
    store: RwLock<Option<AnyStore>>,    // Option is used to allow for the store to be closed
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
        let name = self
            .store
            .read()
            .unwrap()
            .as_ref()
            .ok_or(STORE_CLOSED_ERROR!())?
            .create_profile(profile)
            .await?;
        Ok(name)
    }

    pub fn get_profile_name(&self) -> Result<String, ErrorCode> {
        let name = self
            .store
            .read()
            .unwrap()
            .as_ref()
            .ok_or(STORE_CLOSED_ERROR!())?
            .get_profile_name().to_string();
        Ok(name)
    }

    pub async fn remove_profile(&self, profile: String) -> Result<bool, ErrorCode> {
        let removed = self
            .store
            .read()
            .unwrap()
            .as_ref()
            .ok_or(STORE_CLOSED_ERROR!())?
            .remove_profile(profile)
            .await?;
        Ok(removed)
    }

    pub async fn rekey(&self, key_method: Option<String>, pass_key: Option<String>) -> Result<(), ErrorCode> {
        let key_method = match key_method {
            Some(method) => StoreKeyMethod::parse_uri(&method)?,
            None => StoreKeyMethod::default()
        };
        let pass_key = PassKey::from(pass_key.as_deref()).into_owned();
        self
            .store
            .write()
            .unwrap()
            .as_mut()
            .ok_or(STORE_CLOSED_ERROR!())?
            .rekey(key_method, pass_key)
            .await?;
        Ok(())
    }

    pub async fn close(&self) -> Result<(), ErrorCode> {
        let store = self.store.write().unwrap().take();
        store
            .ok_or(STORE_CLOSED_ERROR!())?
            .close().await?;
        Ok(())
    }

    pub async fn scan(
        &self,
        profile: Option<String>,
        categogy: String,
        tag_filter: Option<String>,
        offset: Option<i64>,
        limit: Option<i64>,
    ) -> Result<Arc<AskarScan>, ErrorCode> {
        let tag_filter = tag_filter.as_deref().map(TagFilter::from_str).transpose()?;
        let scan = self
            .store
            .read()
            .unwrap()
            .as_ref()
            .ok_or(STORE_CLOSED_ERROR!())?
            .scan(
                profile,
                categogy,
                tag_filter,
                offset,
                limit,
            )
            .await?;
        Ok(Arc::new(AskarScan::new(scan)))
    }
}
