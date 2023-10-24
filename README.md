# DIN (Do it no)

더 나은 사람이 되기 위한 ‘Project 50 Challenge’에 영감을 받아 앱을 제작하게 되었습니다.<br/>
텍스트만 있는 심플한 To-Do 앱이 아닌 첨부한 이미지를 통해 동기부여가 되고 생성한 목표를 별점으로 평가하고 그 평가는 차트를 통해 확인하는 등의 기능들을 넣어 목표한 바를 이루는데 도움이 되고자 했습니다.

<br />

# 프로젝트 기간
> 2022년 6월 - 2022년 9월

<br />

# 기술스택
<img src="https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=Flutter&Color=white"/>  <img src="https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=Dart&Color=white"/> <img src="https://img.shields.io/badge/Firebase-E8E8E8?style=for-the-badge&logo=Firebase&Color=white"/> <img src="https://img.shields.io/badge/github-181717?style=for-the-badge&logo=github&logoColor=white"> <img src="https://img.shields.io/badge/git-F05032?style=for-the-badge&logo=git&logoColor=white">

<br />

# 상세 화면
## 회원가입 & 로그인
![signup_and_signin](https://github.com/shinung-han/din/assets/118904460/8d9b983a-5bc9-4c5c-85a4-117e46d0b2ce) ![google_login](https://github.com/shinung-han/din/assets/118904460/af610246-348d-424c-920f-a1d1767cd9ca) 

- 왼쪽 : 이메일 & 비밀번호 회원가입 -> 튜토리얼 -> 로그아웃 -> 로그인
- 오른쪽 : 소셜 로그인(회원가입)
  - 프로필 페이지에서 로그인 된 방법 확인 가능
  
<br />

## 회원가입 시 유효성 검사 & 비밀번호 재설정
![유효성 검사](https://github.com/shinung-han/din/assets/118904460/bfd02f2b-9209-470e-a0ba-b8aeec2354cd) ![비밀번호 재설정](https://github.com/shinung-han/din/assets/118904460/8ebca2bb-8dd0-45dc-a3d7-57539544d129)
- 왼쪽 : 유효성 검사
- 오른쪽 : 비밀번호 재설정 위한 이메일 발송

<br />

## 프로젝트 생성
![프로젝트 생성-01](https://github.com/shinung-han/din/assets/118904460/3e7e71bd-559f-4aa7-8b0f-c81a8f7d890c) ![프로젝트 생성-02](https://github.com/shinung-han/din/assets/118904460/00ee62c1-6240-4340-8fd4-adac967b78d3) ![프로젝트 생성-03](https://github.com/shinung-han/din/assets/118904460/d06a5ce6-4e3a-45b1-8b0f-4726d5b5fe3f)

- 첫 번째 : 프로젝트 생성 시작
  - 날짜 선택 (시작, 종료일 동일한 날짜 선택 불가능)
  - 목표 생성 페이지 (목표 없을 경우 에러 메시지) 
- 두 번째 : 목표의 제목, 이미지 수정 및 삭제
- 세 번째 : 프로젝트 생성 후
  - 카드 형식의 목표들
  - 달력 및 통계 페이지에도 프로젝트 생성

<br />

## 프로젝트 완료 & 세팅
![프로젝트 완료](https://github.com/shinung-han/din/assets/118904460/50ac9ef9-7b7d-4a28-9ea9-0444fc53eb29) ![프로젝트 세팅](https://github.com/shinung-han/din/assets/118904460/e8efa3ac-7597-458e-b923-00b8044600b1)
- 왼쪽 : 프로젝트 완료
  - 별점으로 목표 평가 (달력, 통계에 반영)
  - 메모 기능(달력 탭에서 확인 가능)
- 오른쪽 : 프로젝트 세팅
  - 목표의 제목, 이미지 변경 가능 (수정 후 달력과 통계에 바로 적용)
  - 프로젝트 삭제 기능 

<br/>

## 남은 기간 안내 및 명언
![남은 기간](https://github.com/shinung-han/din/assets/118904460/3a93791c-fb3f-414f-822d-fa55581e25cb)
- 프로젝트 시작 전까지 남은 기간을 볼 수 있고 랜덤으로 명언 제공

<br />

## 달력 & 통계 페이지
![탭별 구성](https://github.com/shinung-han/din/assets/118904460/e48b9c36-7250-44ef-8451-9f8f69d77ad2)
- 달력 페이지
  - 별점 및 메모 확인
  - 1,2주 또는 1개월 형식 전환 기능
- 통계 페이지
  - 주간 활동한 목표들의 통계
  - 목표 개별간 활동한 통계
 
<br/>

## 프로필 변경
![프로필변경](https://github.com/shinung-han/din/assets/118904460/3537d95a-9333-4908-8763-df76a8fae3fa)  ![비밀번호 변경](https://github.com/shinung-han/din/assets/118904460/e4925e68-77fb-485b-a5ee-4099a99f7128)
- 왼쪽 : 사용자 이름 및 이미지 변경
- 오른쪽 : 비밀번호 변경

<br />

# Dependencies
```
  image_picker: ^1.0.0
  go_router: ^9.0.3
  flutter_riverpod: ^2.3.6
  flutter_animate: 4.2.0
  firebase_core: ^2.14.0
  firebase_auth: ^4.6.3
  cloud_firestore: ^4.8.2
  firebase_storage: ^11.2.4
  google_sign_in: ^6.1.4
  http: ^1.1.0
  google_fonts: ^5.1.0
  intl: ^0.18.1
  smooth_page_indicator: ^1.1.0
  table_calendar: ^3.0.9
  shared_preferences: ^2.2.0
  fl_chart: ^0.63.0
  cached_network_image: ^3.2.3
  flutter_rating_bar: ^4.0.1
  flutter_native_splash: ^2.3.2
  app_tracking_transparency: ^2.0.4
  google_mobile_ads: ^3.0.0
  flutter_dotenv: ^5.1.0
```




