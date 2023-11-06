---
layout: cover
---

# Navigate like App in LiveView
<br />

Spark

(2023. 11. 03)

---
---

# LiveView 화면 이동의 종류
<br />

- Phoenix.Component.link/1
- Phoenix.LiveView.push_navigate/2
- Phoenix.LiveView.push_patch/2
- 뒤로가기

---
layout: statement
---

# 뒤로가기?

---
---

# 뒤로가기 버튼 구현 방법
<br />

### JavaScript

- `history.go(-1)`
<br />
<br />


### Elixir

- link 컴포넌트에 이전 화면의 path를 하드코딩하여 각 화면에 배치

---
---

# JavaScript를 사용해 뒤로가기 버튼을 구현한 이유
<br />

### 1. 시스템 뒤로가기 버튼과 동작을 일치시키기 위해

- Android 뒤로가기 버튼
- iOS Interactive Pop Gesture
- 웹 브라우저 뒤로가기 버튼

<br />

### 2. 직전 페이지의 Query Parameters를 유지하기 위해

---
---
# hooks.js
<br />

### Hook

```js
export default {
  NavigateBack: {
    mounted() {
      this.el.addEventListener("click", () => {
        history.go(-1)
      })
    }
  }
}
```
<br />

### Template

```html
<button id="navigate-back" phx-hook="NavigateBack" type="button">
  back
</button>
```

---
layout: statement
---

# + 화면 간 값 전달

---
---

# 일반적인 앱에서 화면 간 값 전달 방법
<br />

### Pass `song` in Flutter
<br />

```dart{5}
// ...
onPressed: () {
  Navigator.of(context).push(
    MaterialPageRoute(
      builder: (context) => const SongScreen(song: song),
    ),
  );
},
child: Text(song.name),
// ...
```

- LiveView에서도 하나의 LiveView에 여러개의 LiveComponent를 사용하면 동일하게 구현 가능

---
layout: statement
---

# 단점 1. 테스트 코드 작성이 어려움

---
---

# 하나의 LiveView를 여러 개로 분리

- 기존의 구현은 한 LiveView를 여러 LiveComponent들 간 값 전달의 매개로 사용
- LiveView 간 값을 전달하기 위해 별도의 외부 저장소 도입

---
---

# 외부 저장소 선택지

- Query Parameters
- Client-side Storages
  - Cookies
  - Session Storage
  - Indexed DB
  - ...
- Server-side Storages
  - Erlang Term Storage
  - ...

---
---

# Query Parameters 사용 시

- 서버를 Stateless Server로 유지할 수 있음
- Query Parameters에 접근하지 못하는 콜백이 많으므로 assigns로 복사해야함
- 화면 이동에 대비해 자주 push_patch를 통해 Query Parameters를 화면과 동기화해야함
- link 컴포넌트 사용 시 Query Parameters 전달을 신경써야함
- 브라우저 history에 기록이 남으므로 보안에 신경써야함
- 복잡한 데이터를 전달하기 어려움

---
---

# Server-side Storage 사용 시

- `Phoenix.LiveView.Socket`의 `id`를 키로 사용하여 복잡한 데이터도 쉽게 저장 가능
- Stateful Server를 관리해야함

---
layout: statement
---

# 단점 2. live-reloading 시<br />항상 첫 화면으로 돌아감

---
---

# 별도의 id를 도입

- `Phoenix.LiveView.Socket`의 `id`는 live reload 시 바뀜
- Pentos의 경우 nid를 Query Parameters로 전달
- 이로 인해 `Phoenix.LiveView.Socket`의 구현에 의존하지 않게 됨
- link 컴포넌트를 통해 쉽게 전달할 방법 필요

---
---

# 요약

- 브라우저 환경과 앱 환경의 네비게이션 경험을 둘다 만족시키기는 어려움
- Pentos의 경우 화면 간 값 전달을 위해 별도의 외부 저장소를 도입
- 화면 분리로 인해 테스트 코드 작성이 얼마나 편해졌는지 확인 필요

---
layout: end
---

# END
