use std::convert::Into;
use crate::{
    crypto::alg::{KeyAlg, AesTypes, BlsCurves, Chacha20Types, EcCurves},
    kms::LocalKey,
    uffi::error::ErrorCode,
};

#[derive(uniffi::Enum)]
pub enum AskarKeyAlg {
    A128GCM,
    A256GCM,
    A128CBC_HS256,
    A256CBC_HS512,
    A128KW,
    A256KW,
    BLS12_381_G1,
    BLS12_381_G2,
    BLS12_381_G1G2,
    C20P,
    XC20P,
    ED25519,
    X25519,
    K256,
    P256,
}

impl Into<KeyAlg> for AskarKeyAlg {
    fn into(self) -> KeyAlg {
        match self {
            AskarKeyAlg::A128GCM => KeyAlg::Aes(AesTypes::A128Gcm),
            AskarKeyAlg::A256GCM => KeyAlg::Aes(AesTypes::A256Gcm),
            AskarKeyAlg::A128CBC_HS256 => KeyAlg::Aes(AesTypes::A128CbcHs256),
            AskarKeyAlg::A256CBC_HS512 => KeyAlg::Aes(AesTypes::A256CbcHs512),
            AskarKeyAlg::A128KW => KeyAlg::Aes(AesTypes::A128Kw),
            AskarKeyAlg::A256KW => KeyAlg::Aes(AesTypes::A256Kw),
            AskarKeyAlg::BLS12_381_G1 => KeyAlg::Bls12_381(BlsCurves::G1),
            AskarKeyAlg::BLS12_381_G2 => KeyAlg::Bls12_381(BlsCurves::G2),
            AskarKeyAlg::BLS12_381_G1G2 => KeyAlg::Bls12_381(BlsCurves::G1G2),
            AskarKeyAlg::C20P => KeyAlg::Chacha20(Chacha20Types::C20P),
            AskarKeyAlg::XC20P => KeyAlg::Chacha20(Chacha20Types::XC20P),
            AskarKeyAlg::ED25519 => KeyAlg::Ed25519,
            AskarKeyAlg::X25519 => KeyAlg::X25519,
            AskarKeyAlg::K256 => KeyAlg::EcCurve(EcCurves::Secp256k1),
            AskarKeyAlg::P256 => KeyAlg::EcCurve(EcCurves::Secp256r1),
        }
    }
}

#[derive(uniffi::Enum)]
pub enum SeedMethod {
    BlsKeyGen,
}

impl Into<&str> for SeedMethod {
    fn into(self) -> &'static str {
        match self {
            SeedMethod::BlsKeyGen => "bls_keygen",
        }
    }
}

pub struct AskarLocalKey {
    pub key: LocalKey,
}

impl AskarLocalKey {
    pub fn generate(alg: AskarKeyAlg, ephemeral: bool) -> Result<Self, ErrorCode> {
        let key = LocalKey::generate(alg.into(), ephemeral)?;
        Ok(Self { key })
    }

    pub fn from_seed(alg: AskarKeyAlg, seed: Vec<u8>, method: Option<SeedMethod>) -> Result<Self, ErrorCode> {
        let key = LocalKey::from_seed(alg.into(), &seed, method.map(|m| m.into()))?;
        Ok(Self { key })
    }
}
