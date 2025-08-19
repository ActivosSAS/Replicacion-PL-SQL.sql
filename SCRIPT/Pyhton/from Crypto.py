from Crypto.Cipher import AES
from Crypto.Util.Padding import unpad
import binascii

# 🔧 VARIABLES MODIFICABLES
# Encriptado en hexadecimal o base64 (de Oracle)
encrypted_hex = "44ABF0EC28BCD983D9782C91794683F3"  # ⚠️ Reemplaza por tu valor real
vclogin = "1113660755"
vcinput_key = f"S1T10_{vclogin}"

# 🔐 FUNCIÓN DE DESENCRIPTADO
def fb_decryption_pad_pkcs5(encrypted_hex: str, vcinput_key: str) -> str:
    encrypted_bytes = bytes.fromhex(encrypted_hex)
    key_raw = vcinput_key.encode('utf-8')

    # Ajustar clave a 32 bytes
    if len(key_raw) > 32:
        key_raw = key_raw[:32]
    else:
        key_raw = key_raw.ljust(32, b'0')

    iv = b'\x00' * 16  # IV de 16 bytes en cero como por defecto en Oracle

    cipher = AES.new(key_raw, AES.MODE_CBC, iv)
    decrypted = cipher.decrypt(encrypted_bytes)
    unpadded = unpad(decrypted, AES.block_size)

    return unpadded.decode('utf-8')

# 🔄 EJECUCIÓN
if __name__ == "__main__":
    try:
        resultado = fb_decryption_pad_pkcs5(encrypted_hex, vcinput_key)
        print("🔓 Clave desencriptada:", resultado)
    except Exception as e:
        print("❌ Error al desencriptar:", str(e))
