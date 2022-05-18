/* eslint-disable @typescript-eslint/no-unsafe-call */
import { refType } from 'ref-napi'

import {
  FFI_STRING,
  FFI_ERROR_CODE,
  FFI_STRING_PTR,
  SecretBufferStruct,
  FFI_INT32,
  FFI_CALLBACK_PTR,
  FFI_ENTRY_LIST_HANDLE,
  FFI_INT32_PTR,
  FFI_POINTER,
  ByteBufferStruct,
  EncryptedBufferStruct,
  FFI_INT64,
  AeadParamsStruct,
  FFI_INT8,
  FFI_KEY_ENTRY_LIST_HANDLE,
  FFI_INT8_PTR,
  FFI_SCAN_HANDLE,
  FFI_CALLBACK_ID,
  FFI_STORE_HANDLE,
  FFI_SESSION_HANDLE,
  FFI_LOCAL_KEY_HANDLE,
} from './utils'

export const nativeBindings = {
  // first element is method return type, second element is list of method argument types
  askar_version: [FFI_STRING, []],
  askar_get_current_error: [FFI_ERROR_CODE, [FFI_STRING_PTR]],
  askar_buffer_free: [FFI_ERROR_CODE, [SecretBufferStruct()]],
  askar_clear_custom_logger: [FFI_ERROR_CODE, []],
  askar_set_custom_logger: [FFI_ERROR_CODE, [FFI_INT32, FFI_CALLBACK_PTR, FFI_INT32, FFI_INT32, FFI_INT32]],
  askar_set_default_logger: [FFI_ERROR_CODE, []],
  askar_set_max_log_level: [FFI_ERROR_CODE, [FFI_INT32]],

  askar_entry_list_count: [FFI_ERROR_CODE, [FFI_ENTRY_LIST_HANDLE, FFI_INT32_PTR]],
  askar_entry_list_free: [FFI_ERROR_CODE, [FFI_ENTRY_LIST_HANDLE]],
  askar_entry_list_get_category: [FFI_ERROR_CODE, [FFI_ENTRY_LIST_HANDLE, FFI_INT32, FFI_STRING_PTR]],
  askar_entry_list_get_name: [FFI_ERROR_CODE, [FFI_ENTRY_LIST_HANDLE, FFI_INT32, FFI_STRING_PTR]],
  askar_entry_list_get_tags: [FFI_ERROR_CODE, [FFI_ENTRY_LIST_HANDLE, FFI_INT32, FFI_STRING_PTR]],
  askar_entry_list_get_value: [FFI_ERROR_CODE, [FFI_ENTRY_LIST_HANDLE, FFI_INT32, refType(SecretBufferStruct())]],

  askar_key_aead_decrypt: [
    FFI_ERROR_CODE,
    [FFI_POINTER, ByteBufferStruct, ByteBufferStruct, ByteBufferStruct, ByteBufferStruct, SecretBufferStruct()],
  ],
  askar_key_aead_encrypt: [
    FFI_ERROR_CODE,
    [FFI_POINTER, ByteBufferStruct, ByteBufferStruct, ByteBufferStruct, EncryptedBufferStruct()],
  ],
  askar_key_aead_get_padding: [FFI_ERROR_CODE, [FFI_POINTER, FFI_INT64, FFI_INT32_PTR]],
  askar_key_aead_get_params: [FFI_ERROR_CODE, [FFI_POINTER, refType(AeadParamsStruct)]],
  askar_key_aead_random_nonce: [FFI_ERROR_CODE, [FFI_POINTER, refType(SecretBufferStruct())]],
  askar_key_convert: [FFI_ERROR_CODE, [FFI_POINTER, FFI_STRING, refType(FFI_POINTER)]],
  askar_key_crypto_box: [
    FFI_ERROR_CODE,
    [FFI_POINTER, FFI_POINTER, ByteBufferStruct, ByteBufferStruct, refType(SecretBufferStruct())],
  ],
  askar_key_crypto_box_open: [
    FFI_ERROR_CODE,
    [FFI_POINTER, FFI_POINTER, ByteBufferStruct, ByteBufferStruct, refType(SecretBufferStruct())],
  ],
  askar_key_crypto_box_random_nonce: [FFI_ERROR_CODE, [refType(SecretBufferStruct())]],
  askar_key_crypto_box_seal: [FFI_ERROR_CODE, [FFI_POINTER, ByteBufferStruct, refType(SecretBufferStruct())]],
  askar_key_crypto_box_seal_open: [FFI_ERROR_CODE, [FFI_POINTER, ByteBufferStruct, refType(SecretBufferStruct())]],
  askar_key_derive_ecdh_1pu: [
    FFI_ERROR_CODE,
    [
      FFI_STRING,
      FFI_POINTER,
      FFI_POINTER,
      FFI_POINTER,
      ByteBufferStruct,
      ByteBufferStruct,
      ByteBufferStruct,
      ByteBufferStruct,
      FFI_INT8,
      refType(FFI_POINTER),
    ],
  ],
  askar_key_derive_ecdh_es: [
    FFI_ERROR_CODE,
    [
      FFI_STRING,
      FFI_POINTER,
      FFI_POINTER,
      ByteBufferStruct,
      ByteBufferStruct,
      ByteBufferStruct,
      FFI_INT8,
      refType(FFI_POINTER),
    ],
  ],
  askar_key_entry_list_count: [FFI_ERROR_CODE, [FFI_KEY_ENTRY_LIST_HANDLE, FFI_INT32_PTR]],
  askar_key_entry_list_free: [FFI_ERROR_CODE, [FFI_KEY_ENTRY_LIST_HANDLE]],
  askar_key_entry_list_get_algorithm: [FFI_ERROR_CODE, [FFI_KEY_ENTRY_LIST_HANDLE, FFI_INT32, FFI_STRING_PTR]],
  askar_key_entry_list_get_metadata: [FFI_ERROR_CODE, [FFI_KEY_ENTRY_LIST_HANDLE, FFI_INT32, FFI_STRING_PTR]],
  askar_key_entry_list_get_name: [FFI_ERROR_CODE, [FFI_KEY_ENTRY_LIST_HANDLE, FFI_INT32, FFI_STRING_PTR]],
  askar_key_entry_list_get_tags: [FFI_ERROR_CODE, [FFI_KEY_ENTRY_LIST_HANDLE, FFI_INT32, FFI_STRING_PTR]],
  askar_key_entry_list_load_local: [FFI_ERROR_CODE, [FFI_KEY_ENTRY_LIST_HANDLE, FFI_INT32, refType(FFI_POINTER)]],
  askar_key_free: [FFI_ERROR_CODE, [FFI_POINTER]],
  askar_key_from_jwk: [FFI_ERROR_CODE, [ByteBufferStruct, refType(FFI_POINTER)]],
  askar_key_from_key_exchange: [FFI_ERROR_CODE, [FFI_STRING, FFI_POINTER, FFI_POINTER, FFI_LOCAL_KEY_HANDLE]],
  askar_key_from_public_bytes: [FFI_ERROR_CODE, [FFI_STRING, ByteBufferStruct, FFI_LOCAL_KEY_HANDLE]],
  askar_key_from_secret_bytes: [FFI_ERROR_CODE, [FFI_STRING, ByteBufferStruct, refType(FFI_POINTER)]],
  askar_key_from_seed: [FFI_ERROR_CODE, [FFI_STRING, ByteBufferStruct, FFI_STRING, FFI_LOCAL_KEY_HANDLE]],
  askar_key_generate: [FFI_ERROR_CODE, [FFI_STRING, FFI_INT8, FFI_LOCAL_KEY_HANDLE]],
  askar_key_get_algorithm: [FFI_ERROR_CODE, [FFI_POINTER, FFI_STRING_PTR]],
  askar_key_get_ephemeral: [FFI_ERROR_CODE, [FFI_POINTER, FFI_INT8_PTR]],
  askar_key_get_jwk_public: [FFI_ERROR_CODE, [FFI_POINTER, FFI_STRING, FFI_STRING_PTR]],
  askar_key_get_jwk_secret: [FFI_ERROR_CODE, [FFI_POINTER, refType(SecretBufferStruct())]],
  askar_key_get_jwk_thumbprint: [FFI_ERROR_CODE, [FFI_POINTER, FFI_STRING, FFI_STRING_PTR]],
  askar_key_get_public_bytes: [FFI_ERROR_CODE, [FFI_POINTER, refType(SecretBufferStruct())]],
  askar_key_get_secret_bytes: [FFI_ERROR_CODE, [FFI_POINTER, refType(SecretBufferStruct())]],
  askar_key_sign_message: [FFI_ERROR_CODE, [FFI_POINTER, ByteBufferStruct, FFI_STRING, refType(SecretBufferStruct())]],
  askar_key_unwrap_key: [
    FFI_ERROR_CODE,
    [FFI_POINTER, FFI_STRING, ByteBufferStruct, ByteBufferStruct, ByteBufferStruct, refType(FFI_POINTER)],
  ],
  askar_key_verify_signature: [
    FFI_ERROR_CODE,
    [FFI_POINTER, ByteBufferStruct, ByteBufferStruct, FFI_STRING, FFI_INT8_PTR],
  ],
  askar_key_wrap_key: [FFI_ERROR_CODE, [FFI_POINTER, FFI_POINTER, ByteBufferStruct, refType(EncryptedBufferStruct())]],

  askar_scan_free: [FFI_ERROR_CODE, [FFI_SCAN_HANDLE]],
  askar_scan_next: [FFI_ERROR_CODE, [FFI_SCAN_HANDLE, FFI_CALLBACK_PTR, FFI_CALLBACK_ID]],
  askar_scan_start: [
    FFI_ERROR_CODE,
    [FFI_STORE_HANDLE, FFI_STRING, FFI_STRING, FFI_STRING, FFI_INT64, FFI_INT64, FFI_CALLBACK_PTR, FFI_CALLBACK_ID],
  ],

  askar_session_close: [FFI_ERROR_CODE, [FFI_SESSION_HANDLE, FFI_INT8, FFI_CALLBACK_PTR, FFI_CALLBACK_ID]],
  askar_session_count: [
    FFI_ERROR_CODE,
    [FFI_SESSION_HANDLE, FFI_STRING, FFI_STRING, FFI_CALLBACK_PTR, FFI_CALLBACK_ID],
  ],
  askar_session_fetch: [
    FFI_ERROR_CODE,
    [FFI_SESSION_HANDLE, FFI_STRING, FFI_STRING, FFI_INT8, FFI_CALLBACK_PTR, FFI_CALLBACK_ID],
  ],
  askar_session_fetch_all: [
    FFI_ERROR_CODE,
    [FFI_SESSION_HANDLE, FFI_STRING, FFI_STRING, FFI_INT64, FFI_INT8, FFI_CALLBACK_PTR, FFI_CALLBACK_ID],
  ],
  askar_session_fetch_all_keys: [
    FFI_ERROR_CODE,
    [FFI_SESSION_HANDLE, FFI_STRING, FFI_STRING, FFI_STRING, FFI_INT64, FFI_INT8, FFI_CALLBACK_PTR, FFI_CALLBACK_ID],
  ],
  askar_session_fetch_key: [
    FFI_ERROR_CODE,
    [FFI_SESSION_HANDLE, FFI_STRING, FFI_INT8, FFI_CALLBACK_PTR, FFI_CALLBACK_ID],
  ],
  askar_session_insert_key: [
    FFI_ERROR_CODE,
    [FFI_SESSION_HANDLE, FFI_POINTER, FFI_STRING, FFI_STRING, FFI_STRING, FFI_INT64, FFI_CALLBACK_PTR, FFI_CALLBACK_ID],
  ],
  askar_session_remove_all: [
    FFI_ERROR_CODE,
    [FFI_SESSION_HANDLE, FFI_STRING, FFI_STRING, FFI_CALLBACK_PTR, FFI_CALLBACK_ID],
  ],
  askar_session_remove_key: [FFI_ERROR_CODE, [FFI_SESSION_HANDLE, FFI_STRING, FFI_CALLBACK_PTR, FFI_CALLBACK_ID]],
  askar_session_start: [FFI_ERROR_CODE, [FFI_STORE_HANDLE, FFI_STRING, FFI_INT8, FFI_CALLBACK_PTR, FFI_CALLBACK_ID]],
  askar_session_update: [
    FFI_ERROR_CODE,
    [
      FFI_SESSION_HANDLE,
      FFI_INT8,
      FFI_STRING,
      FFI_STRING,
      ByteBufferStruct,
      FFI_STRING,
      FFI_INT64,
      FFI_CALLBACK_PTR,
      FFI_CALLBACK_ID,
    ],
  ],
  askar_session_update_key: [
    FFI_ERROR_CODE,
    [FFI_SESSION_HANDLE, FFI_STRING, FFI_STRING, FFI_STRING, FFI_INT64, FFI_CALLBACK_PTR, FFI_CALLBACK_ID],
  ],

  askar_store_close: [FFI_ERROR_CODE, [FFI_STORE_HANDLE, FFI_CALLBACK_PTR, FFI_CALLBACK_ID]],
  askar_store_create_profile: [FFI_ERROR_CODE, [FFI_STORE_HANDLE, FFI_STRING, FFI_CALLBACK_PTR, FFI_CALLBACK_ID]],
  askar_store_generate_raw_key: [FFI_ERROR_CODE, [ByteBufferStruct, FFI_STRING_PTR]],
  askar_store_get_profile_name: [FFI_ERROR_CODE, [FFI_STORE_HANDLE, FFI_CALLBACK_PTR, FFI_CALLBACK_ID]],
  askar_store_open: [
    FFI_ERROR_CODE,
    [FFI_STRING, FFI_STRING, FFI_STRING, FFI_STRING, FFI_CALLBACK_PTR, FFI_CALLBACK_ID],
  ],
  askar_store_provision: [
    FFI_ERROR_CODE,
    [FFI_STRING, FFI_STRING, FFI_STRING, FFI_STRING, FFI_INT8, FFI_CALLBACK_PTR, FFI_CALLBACK_ID],
  ],
  askar_store_rekey: [FFI_ERROR_CODE, [FFI_STORE_HANDLE, FFI_STRING, FFI_STRING, FFI_CALLBACK_PTR, FFI_CALLBACK_ID]],
  askar_store_remove: [FFI_ERROR_CODE, [FFI_STRING, FFI_CALLBACK_PTR, FFI_CALLBACK_ID]],
  askar_store_remove_profile: [FFI_ERROR_CODE, [FFI_STORE_HANDLE, FFI_STRING, FFI_CALLBACK_PTR, FFI_CALLBACK_ID]],
} as const

// We need a mapping from string type value => type (property 'string' maps to type string)
interface StringTypeMapping {
  pointer: Buffer
  'char*': Buffer
  string: string
  int64: number
  int32: number
  int8: number
  int: number
}

// Needed so TS stops complaining about index signatures
type ShapeOf<T> = {
  [Property in keyof T]: T[Property]
}
type StringTypeArrayToTypes<List extends Array<keyof StringTypeMapping>> = {
  [Item in keyof List]: List[Item] extends keyof StringTypeMapping ? StringTypeMapping[List[Item]] : Buffer
}

type TypedMethods<Base extends { [method: string | number | symbol]: [any, any[]] }> = {
  [Property in keyof Base]: (
    ...args: StringTypeArrayToTypes<Base[Property][1]> extends any[] ? StringTypeArrayToTypes<Base[Property][1]> : []
  ) => StringTypeMapping[Base[Property][0]]
}
type Mutable<T> = {
  -readonly [K in keyof T]: Mutable<T[K]>
}

export type NativeMethods = TypedMethods<ShapeOf<Mutable<typeof nativeBindings>>>
