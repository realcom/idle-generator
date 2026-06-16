# Ninja2 Title Splash Art A

## Intent

`ninja2`의 첫 진입/스플래시 후보. 플레이어가 게임 이름 `나뭇잎마을 키우기`를 바로 읽고, 이후 하우징 홈의 등불 성소와 숲 마을 성장 루프로 자연스럽게 들어가도록 키아트와 타이틀 로고를 함께 잡는다.

## Art Anchor

- 기준 톤은 `art-direction.yaml`의 lantern sanctuary home plus forest survival sortie다.
- 주인공은 갈색 머리, 크림 망토, 붉은 스카프, 이마 잎 흉터, 손등불을 가진 SD 성소 수호자로 유지한다.
- 마을 정체성은 중앙 등불 신전, 작은 목조 지붕, 대나무, 주민, 청록 영혼불, 따뜻한 랜턴 골드로 표현한다.
- 닌자성은 검은 복면/헤드밴드/카타나보다 “숲 성소를 지키는 보호자” 쪽에 둔다.

## Composition Rules

- Portrait 9:16 모바일 스플래시.
- 상단 20%는 타이틀 로고 전용 영역이다. 배경 원화에는 텍스트를 생성하지 않고, 별도 한글 로고 PNG를 얹었다.
- 중앙은 등불 신전과 마을 진입로가 읽히고, 하단 오른쪽은 수호자 캐릭터가 시선을 받는다.
- 숲 잎사귀 프레임은 화면 가장자리에 두고, 타이틀 뒤에는 하늘빛 여백과 부드러운 크림 글로우를 유지한다.

## UI Direction

- 타이틀 문구는 정확히 `나뭇잎마을 키우기`.
- 타이틀은 런타임 텍스트가 아니라 스플래시/브랜드 로고 후보로 저장했다.
- 색은 짙은 잉크 외곽선, 양피지 크림, 랜턴 골드, 녹색 잎 장식으로 기존 Ninja2 UI 스킨과 맞춘다.
- 추가 버튼, 로딩 문구, 버전 표기는 이 이미지에 굽지 않는다.

## Implementation Notes

- 원화 생성은 built-in imagegen으로 처리했고, 한글 타이틀은 로컬 PIL 합성으로 정확도를 보장했다.
- 생성 원화는 `ninja2_title_splash_art_a.source.png`로 보존한다.
- 투명 타이틀 로고는 `harness/design/ninja2/assets/ui/title/title_logo_namutip_maeul_grow_v1.png`에 저장한다.
- 최종 합성 스플래시는 `harness/design/ninja2/assets/ui/title/title_splash_namutip_maeul_grow_v1.png`와 runtime 동일 경로에 복사했다.
- 다음 패스에서 앱 첫 화면을 만들면 이 이미지를 배경으로 쓰고, 시작/계정/로딩 UI는 별도 네이티브 레이어로 얹는다.

## Target Runtime Notes

- Runtime asset: `harness/runtime/assets/ninja2/ui/title/title_splash_namutip_maeul_grow_v1.png`
- Runtime logo asset: `harness/runtime/assets/ninja2/ui/title/title_logo_namutip_maeul_grow_v1.png`
- 원본 해상도는 941x1672이며, 9:16 비율을 유지한다.

## Source Image

Generated with built-in imagegen.

Original generated source:
`/Users/yangjinhwan/.codex/generated_images/019eb8fa-a7d5-7592-8715-3f1c9e7d2091/ig_06251bb7b4db154e016a2b428d9874819192d454f9c3fd9ae9.png`

Local textless source:
`harness/design/ninja2/concepts/ninja2_title_splash_art_a.source.png`

![Ninja2 title splash art A](ninja2_title_splash_art_a.png)
