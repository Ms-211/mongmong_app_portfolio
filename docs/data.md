> 공개 데모 기준 문서입니다. Wi-Fi·QR·이미지·폰트·게임 위치와 메뉴 가격은 데모용으로 교체했으며 운영 배포 설정은 제외했습니다.

# 데이터 구조와 수정 방법

## 저장 위치

| 데이터 | 파일 | 문서 작성 시점의 항목 수 |
| --- | --- | ---: |
| 게임 | assets/db/games.json | 409 |
| 메뉴 | assets/db/menus.json | 45 |

두 파일의 최상위 값은 JSON 배열입니다. Repository는 배열을 읽어 각 객체를 Model로 변환합니다. 앱 실행 중 데이터를 저장하거나 원격에서 갱신하는 기능은 없습니다.

## 게임 필드

| 필드 | 기대 값 | 용도 |
| --- | --- | --- |
| game_name | 문자열 | 이름 검색과 표시 |
| min_player / max_player | 정수 | 플레이 가능 인원 범위 |
| recommended_player | 정수 | 일반 인원 필터와 추천 인원 점수 |
| difficulty | 1~5 정수 | 난이도 표시·필터·추천 점수 |
| min_play_time / max_play_time | 정수, 분 | 시간 정보; 검색·추천 계산에는 최대 시간 사용 |
| genre | 문자열 | 장르 필터와 추천 점수 |
| tags | 문자열 또는 null | 추가 태그 표시 |
| zone / location | 문자열 | 매장 내 게임 위치 |
| is_pick / is_active | boolean 또는 0·1 | PICK 점수·정렬, 목록 노출 여부 |
| youtube_id | 문자열 | 설명 영상 ID 또는 현재 파서가 처리하는 주소 |
| image_file | 문자열 | 게임 이미지 파일명 |
| description | 문자열 | 게임 설명 |
| added_dt | 날짜 문자열 | 등록일 표시와 최근 등록 판정 |

### 예시

아래 항목은 형식 설명용 가상 데이터입니다.

```json
[
  {
    "game_name": "예시 전략 게임",
    "min_player": 2,
    "max_player": 4,
    "recommended_player": 4,
    "difficulty": 3,
    "min_play_time": 20,
    "max_play_time": 40,
    "genre": "전략",
    "tags": "입문 전략",
    "zone": "예시 구역",
    "location": "A-1",
    "is_pick": 1,
    "is_active": 1,
    "youtube_id": "",
    "image_file": "example_game.jpg",
    "description": "게임 설명",
    "added_dt": "2026-10-09"
  }
]
```

이미지는 assets/images/games/ 아래에 둡니다. 위 예시는 example_game.jpg가 실제로 있어야 이미지가 표시됩니다.

youtube_id는 가능하면 원본 영상 ID를 사용합니다. 현재 상세 화면은 URL의 v 쿼리 값을 추출하거나 입력 문자열을 물음표·앰퍼샌드에서 자르므로, 모든 YouTube URL 형식을 지원하는 파서는 아닙니다. 예를 들어 youtu.be와 Shorts 주소의 경로에서 ID를 추출하는 처리는 없습니다.

최근 등록 게임은 실행 기기의 현재 날짜로부터 DateTime(year, month - 2, day)를 계산하고, 해당 날짜 이상인 added_dt를 포함합니다. 고정 60일 기준이 아니며 미래 날짜도 별도로 제외하지 않습니다.

## 메뉴 필드

| 필드 | 기대 값 | 용도 |
| --- | --- | --- |
| menu_name | 문자열 | 메뉴 이름 |
| category | 문자열 | 기본 카테고리 |
| sub_category | 문자열 | 값이 있으면 표시 카테고리로 우선 사용 |
| price | 정수 | 가격; 천 단위 구분과 '원' 표기 |
| image_file | 문자열 | 메뉴 이미지 파일명 |

메뉴 이미지는 assets/images/menu/ 아래에 둡니다. displayCategory는 sub_category 또는 category에서 공백을 제거합니다. 현재 화면의 카테고리는 눈꽃빙수·간식·볶음밥·한강라면·논커피·커피·에이드·티·스무디·캔음료로 고정되어 있으므로, 새 카테고리 추가 시 MenuScreen.categories도 함께 변경해야 합니다.

## 수정 순서

1. JSON 배열 안에 항목을 추가하거나 기존 값을 수정합니다.
2. image_file과 같은 이름의 이미지 파일을 대응 폴더에 추가합니다. 대소문자와 확장자까지 확인합니다.
3. genre와 category 값이 화면에서 사용하는 필터·카테고리 문자열과 일치하는지 확인합니다.
4. flutter run -d chrome으로 목록·검색·추천·상세 또는 메뉴 표시를 확인합니다.
5. flutter analyze, flutter test, flutter build web --release로 확인합니다. 공개본에는 자동 배포 설정이 없습니다.

게임·메뉴 이미지 폴더는 pubspec.yaml에 이미 등록되어 있습니다. 다른 경로를 추가할 때는 assets 등록도 확인해야 합니다.

## 데이터 검증 주의점

현재 Model은 누락되거나 해석할 수 없는 숫자를 0, 문자열을 빈 문자열, 날짜를 2024-01-01로 대체합니다. 이러한 기본값은 데이터가 올바르다는 검증을 대신하지 않습니다.

- min_player ≤ recommended_player ≤ max_player인지 확인합니다.
- 인원은 양수, difficulty는 1~5, 플레이 시간은 양수이며 최소 시간이 최대 시간 이하인지 확인합니다.
- 이미지 파일 존재 여부, 영상 ID, 장르와 카테고리 오타를 확인합니다.
- 앱 노출 여부에 맞게 is_active를 설정합니다.
- 가격·매장 위치·등록일이 실제 안내하려는 값과 일치하는지 확인합니다.

매장 안내·이벤트·Wi-Fi 내용은 JSON이 아니라 해당 화면 코드와 이미지에 정의되어 있습니다. 포트폴리오 공개 전에는 Wi-Fi 값을 데모용으로 바꾸고 QR 이미지에도 실제 접속 정보가 남아 있지 않은지 확인해야 합니다. 게임 이미지·QR·폰트의 사용 및 재배포 권한도 별도로 확인합니다.
