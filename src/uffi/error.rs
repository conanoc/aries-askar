use crate::error::{Error, ErrorKind};

#[derive(Debug, PartialEq, Clone, Serialize)]
pub enum ErrorCode {
    Success(String),
    Backend(String),
    Busy(String),
    Duplicate(String),
    Encryption(String),
    Input(String),
    NotFound(String),
    Unexpected(String),
    Unsupported(String),
    Custom(String),
}

impl From<Error> for ErrorCode {
    fn from(err: Error) -> ErrorCode {
        match err.kind() {
            ErrorKind::Backend => ErrorCode::Backend(err.to_string()),
            ErrorKind::Busy => ErrorCode::Busy(err.to_string()),
            ErrorKind::Duplicate => ErrorCode::Duplicate(err.to_string()),
            ErrorKind::Encryption => ErrorCode::Encryption(err.to_string()),
            ErrorKind::Input => ErrorCode::Input(err.to_string()),
            ErrorKind::NotFound => ErrorCode::NotFound(err.to_string()),
            ErrorKind::Unexpected => ErrorCode::Unexpected(err.to_string()),
            ErrorKind::Unsupported => ErrorCode::Unsupported(err.to_string()),
            ErrorKind::Custom => ErrorCode::Custom(err.to_string()),
        }
    }
}
