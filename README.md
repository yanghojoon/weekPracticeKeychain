# Keychain
야곰 아카데미 불타는 토요 스터디에서 진행한 Keychain 관련 공부입니다. 

### 🔐 Keychain은 뭘까?
참고문서: https://developer.apple.com/documentation/security/keychain_services <br> <br>
일단 Keychain은 사용자 대신 작은 단위의 데이터를 안전하게 저장하는 공간을 의미한다. 
여기서 작은 단위의 데이터는 인증서, 비밀번호, 인적사항 등의 데이터를 말한다. 

이때 keychain service API는 키체인이라는 암호화된 데이터베이스에 사용자의 데이터를 저장하는 매커니즘을 가지고 있다. 

단 iOS에서는 하나의 디바이스에 하나의 keychain만 존재하며 번들 단위(앱 단위)로 keychain을 관리하게 되며, MacOS에선 임의로 키체인을 생성할 수 있다는 차이가 존재한다. 

<img width="486" alt="스크린샷 2022-01-23 오후 12 17 25" src="https://user-images.githubusercontent.com/90880660/150663428-aafb26d7-4d39-480b-b0c0-aa8d68ed5d9e.png">

### 📑 Keychain Item
참고문서: https://developer.apple.com/documentation/security/keychain_services/keychain_items <br> <br>
키체인에 저장하게 되는 암호화한 정보를 의미한다. 
예를 들어 패스워드 같은 것을 저장하기 위해선 keychain item으로 만들어줘야 한다. 

<img width="540" alt="스크린샷 2022-01-23 오후 12 21 02" src="https://user-images.githubusercontent.com/90880660/150663482-33afb27e-ce83-46e8-92ac-893608b95ff5.png">

### 🔖 Keychain Attribute
참고문서: https://developer.apple.com/documentation/security/keychain_services/keychain_items/item_attribute_keys_and_values <br> <br>
데이터를 저장하기 위해선 keychain item은 attribute가 필요하다. attribute는 나중에 item을 찾을 수 있도록 도와주며, 데이터를 사용하거나 공유하는 방법을 관리할 수 있도록 한다. 
즉, 데이터를 찾기 위한 tag 역할인 것이다. 

<br>

---
그렇다면 본격적으로 keychain을 어떻게 사용하면 되는지 알아보자. 

### 1️⃣ Adding a Password to the Keychain
참고 문서: https://developer.apple.com/documentation/security/keychain_services/keychain_items/adding_a_password_to_the_keychain <br> <br>
일단 가장 먼저 Keychain에 keychain item을 넣는 방법에 대해 알아보자. 

이번에는 비밀번호만 keychain에 넣을 예정이라 password 프로퍼티만 생성해주었다. 

```swift
    struct Credentials {
        var password: String
    }
```

textfield를 통해 받은 값을 비밀번호에 넣어줬고, 이를 keychain에 넣어주기 위해 기존에 string이었던 비밀번호를 data로 변경해주었다. 
```swift
        guard let inputPassword = passwordTextField.text else { return }
        let credential = Keychain.Credentials(password: inputPassword)
        guard let password = credential.password.data(using: .utf8) else { return }
```

그 후 암호화된 정보를 어디에 넣을지 정해줘야 하기 때문에 query를 정해줬다. 

```swift
var query: [String: Any] = [
    kSecClass as String: kSecClassGenericPassword, // 암호화된 정보를 어디에 넣을 지를 정함(어떤 질문인지 정함)
    kSecValueData as String: password // 내가 여기 넣을 데이터는 password야.
]
```

이후 `SecItemAdd` 메서드를 사용해서 keychain에 값을 넣어줬다. 
위 함수는 OSStatus 값을 반환해주어 키체인에 넣었을 때 상태가 어떤지를 알려주게 된다. 

OSStatus의 경우 숫자로 나오게 되며 [OSStatus](https://www.osstatus.com/)라는 사이트를 통해 어떤 상태인지를 파악할 수 있다. 
현재는 Security 프레임워크를 기반으로 하는 Keychain에 대해 진행하고 있기 때문에 위 사이트에서 Security 프레임워크의 상태를 확인해보면 된다. 

### 2️⃣ Searching for Keychain Items
참고 문서: https://developer.apple.com/documentation/security/keychain_services/keychain_items/searching_for_keychain_items <br> <br>
이렇게 keychain에 추가를 했으면 이를 다시 찾을 수도 있어야 한다. 
그래야 비밀번호도 비교해보고 할 수 있으니 말이다. 

이때도 query를 따로 만들어줘야 한다. add에서 필요한 질문(query)과 찾을 때의 query가 다를 수 있기 때문이다. 

```swift
        var query: [String: Any] = [ // query 질의 -> 물어보는 것. 듣는 쪽은 키체인이고 말하는 것은 우리
            kSecClass as String: kSecClassGenericPassword,
            kSecMatchLimit as String: kSecMatchLimitOne,
            kSecReturnAttributes as String: true, 
            kSecReturnData as String: true
        ]
```

일단 Data를 반환받아야 하기 때문에 `kSecReturnData`를 true로 해주었고 맞는 비밀번호 하나만 필요하기 때문에 `kSecMatchLimit`을 `kSecMatchLimitOne`로 설정해주었다. 
이때 `kSecReturnAttributes`를 true로 해주는 코드가 없을 경우 이를 통해 제대로 값을 찾지 못했다. 

attribute는 따로 넣어주지 않고 데이터만 넣어줬는데도 true로 해줘야 했다. 
이에 대해선 아직 정확한 이유를 파악하진 못했으나 attribute를 Return해줘야 딕셔너리의 키 값이 생기는 것이 아닌가 추측해보았다. 

```swift 
        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)
        guard status != errSecItemNotFound else {
            return
            showAlert(message: "비밀번호 생성해줘")
        }
        guard let existingItem = item as? [String:Any],
              let passwordData = existingItem[kSecValueData as String] as? Data,
              let originPassword = String(data: passwordData, encoding: .utf8),
              inputPassword == originPassword else {
                  showAlert(message: "다른 사람의 일기장을 보면 안돼 🖐🏻")
                  return
              }
```

그리고 item 변수를 생성해주었다. 
이때 item의 Reference를 전달해줘서 `CFTypeRef`를 사용해줬다. 

따라서 `SecItemCopyMatching`의 이름이 그냥 Matching이 아니라 CopyMatching인 이유도 reference인 만큼 Heap에 있는 값을 변경하면 안되기 때문에 copy를 하는 것이 아닐까 생각해봤다.
그리고 매개변수로 받은 item을 변경해주기 떄문에 `&`을 붙여줬다. 

### 3️⃣ Updating and Deleting Keychain Items
참고문서: https://developer.apple.com/documentation/security/keychain_services/keychain_items/updating_and_deleting_keychain_items <br> <br>
마지막으로 keychain을 업데이트하거나 삭제하는 방법이다. 

이것도 앞과 거의 비슷하며 `SecItemDelete`와 `SecItemUpdate`를 사용하면 된다. 

이때 쿼리는 다음과 같이 작성해주었다. 
```swift
        var query: [String: Any] = [ // 기존에 등록되었을 때 사용한 쿼리
            kSecClass as String: kSecClassGenericPassword, 
            kSecValueData as String: password 
        ]
        var updateQuery: [String: Any] = [
            kSecValueData as String: password // 바꿔야 하는 항목만 기재
        ]
```

그리고 위처럼 이렇게 해주면 끝난다. 

```swift
let editstatus = SecItemUpdate(query as CFDictionary, updateQuery as CFDictionary)
```

삭제의 경우 더욱 간단하다. 단순히 기존의 query 그대로 가져와 지워주기만 하면 된다. 
```swift
let status = SecItemDelete(query as CFDictionary)
```

