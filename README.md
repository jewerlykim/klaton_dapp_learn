# klaton_dapp_learn

klaton 특성
- 1초 TPS 3000 이상
- 저렴한 TX Fee
- 확장성 & 프라이버시

solidity, truffle 지원

Tools
Wallet, IDE, Scope

기존 블록체인 약점
1 . Scalability
TPS + Block Interval
TPS(Transaction Per Second)
Block Interval : 블록 생성 간격
Visa : TPS 1700/s
비트코인 : TPS 7/s(현실 2~5) | BI 10분
이더리움 : 15~20            | BI 15에서 20초
ETH : 20tps + 15block interval
20 * 15 = 300 transaction in one block

TPS 10,000 / BI 10분 이면 최대 10분 기다려야함

기존의 블록체인은 왜 느린가?
참여하는 노드가 많다고 빠른게 아님
퍼포먼스가 가장 느린 노드에 맞춰 하향평준화됨
-> 많은 양의 트랜잭션 처리하기 부족하고 네트워크 자체 속도도 느림

2 . Finality(변경 불가능함) - TX가 변경 불가라는 합리적인 보장받기까지 기다려야 되는 시간
TX가 바뀔수 없다는 걸 보증
BTC, ETH -> Finality가 부족함
확률론적 최종성만 제공함. 결제해도 나중에 보면 결제가 안되어있을수도 있음
BTC 블록채굴평균시간 10분 * 6번 검증 = Finality까지 60분 걸림
ETH 블록채굴평균시간 15초 * 25번 검증 = Finality까지 6분 걸림

3 . Fork
작업증명(PoW)방식
- 블록 추가하기 위해 문제품(hash 찾기)
비슷한 시기에 문제를 풀면 분기가 발생하게 됨
먼저 받은 블록 제외 나머지 블록은 무시함.
Longest chain rule 
전체 컴퓨팅 파워의 51프로 이상 가지고 있으면 더 많은 블록 만들어 낼수있음.

Klayton 이해하기
1 . 합의(consensus)
Public - PoW, PoS
private pBFT, Raft

BFT(비잔티움 결함 허용)
- 참여 노드수 제한 / 성능 높임
- 분산화 약화 / 투명성 저하

클레이튼 합의 - IBFT
(이스탄불 비잔티움 결함 허용)
공개를 통한 개인적인 합의 신뢰 모델
private consensus with public disclosure
합의 달성 소수 private 노드
블록 생성 결과 접근 및 검증 노드

pre-prepare / prepare / commit 단계
RR 단계 
Proposer을 뽑음 나머지는 Validator가 됨
pre-prepare
proposer가 블록 만들어서 다른 애들한테 제안함 / 이번엔 내차례야 메세지
prepare에서 검증자들이 자기 제외 한 애들한테 잘 받았다고 보냄
fault는 아무것도 안보내고 받기만함(컴 꺼져있거나, 네트워크 오작동, 혹은 악의)
commit
proposer한테 받은거 수락할 건지 결정 각자 모두에게 응답 보냄(proposer포함)
2/3 이상 승인시 블록 생성하고 넘어감
finality도 여기서 끝 그 즉시 완결성을 가짐
합의자들이 많아지면 오래걸리긴하는데 그 수를 제한해 뒀음

블록 생성 및 전파
블록 생성 사이클 
블록 생성 주기 = 라운드
블록 생성 간격 약 1초
제안자와 위원회 선택
제안자 - 무작위이지만 결정적으로 governance council 노드중에 뽑는다.
각각의 합의 노드가 가장 최근의 블록 헤더에서 파생된 난수 사용, 자기가 라운드에 선택됐는지 증명하는 암호화 작업을 함.

블록 제안과 검증
제안자의 공개키 통해 입증가능한 암호증명 씀
위원회도 증거 제출
-> 누가 제안자고 위원회인지 파악 가능
제안자가 블록 만들고 합의 동의하면 마무리

블록 전파
2/3 이상의 서명을 받아야함
모든 합의에게 전달됨. 프록시 노드를 통해 엔드포인트 노드들에게 전달됨.

클레이튼 네트워크 구조
네트워크(엔드포인트 노드 네트워크가 코어셀 네트워크를 둘러싸고 있는 모양새)
CNN: Consensus Node Network
PNN: Proxy Node Network
ENN: Endpoint Node Network
1 CN - n PN
CN 참여 까다로움
CN은 모두 연결되서 소통가능
CN은 외부와 직접 접촉 불가능 / private한 환경
EN - PN 정보 주고 받음
EN도 서로 연결해서 정보 주고받을수도 잇음. PN 과 연결하면 더 빠르고 신속하게 신뢰도 높은 블록 받을수있음
누구나 EN 될수있음. 웹, 클라이언트에게 서비스 제공 가능
CN bootnode, PN bootnode, EN bootnode 새로 들어온 노드들 도와주는 노드 (klayton 운영)
PN, EN 부트 노드는 공개 CN 은 비공개
PN 부트노드는 허용된 허용된 프록시 노드만 등록 가능하게 도와주고 EN과 연결되게 도와줌
EN 부트노드는 어떤 PN 과 연결될지 EN 도와줌


코어셀
사용자가 많아져서 확장이 필요할 때
일반적 : 서버늘리고 리퀘스트 분할 처리
블록체인 : 노드 늘리면 더 전달 더 많이 해야해서 성능 늘어나는게 아님
노드 자체의 성능을 늘려야함 - 클레이튼
CN 참여조건
physical core가 40개 이상
256GB ram
1년치 데이터 약 14TB 저장
10G 네트워크
전체가 다 성능 향상해야함
1 CN : n PN - EN 연결 지원
만약 EN-CN 직접 연결한다면 CN 으로서 부담이 올수가 있음.

서비스 체인
메인넷과 연결된 독립적으로 운영되는 체인
특별한 노드환경에서 설정
보안 수준 맞춤형으로 설정하고 싶을 때
많은 처리량 요구 / 메인넷 배포시 경제성 낮다고 할때 서비스 체인 사용
메인넷과 연결된 체인들 메인체인과 소통 자유롭지는 않고 제한된 TX로만 가능
독립된 서비스 공간을 구축해서 필요할 때 메인넷에 신뢰를 고정 / GAS 비용 아예 안받게 설정할 수도 있음

이더리움과 클레이튼의 차이
ETH - 단일 네트워크(누구나 블록 생성가능, 가장 먼저 만들고 많이 전파해야함) 합의 PoW 방식
마이닝 노드 - 블록을 쓰고 네트워크에 전파한 노드

클레이튼
Two Layer Architecture Trust Model
클레이튼 caver.js
이더리움 web3.js
솔리디티
트러플 프레임워크

Gas fee = Gas price(ston, 고정) * Gas limit

klay의 단위가 여러개가 있음.

caver.utils 에서 peb - klay 변환가능
