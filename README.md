# pp-main
People post software assembling 

## Design
### Deployment view
```mermaid
graph LR

subgraph SGU1[User 1]
USER_1(User 1):::User <--> DB_11[(pp-node 1)]:::Private1
end

DB_11 <--> DB_21[(pp-node 1)]:::Private1
USER_1 <--> DB_21
DB_11 <--> USER_2(User 2):::User

subgraph SGU2[User 2]
DB_21 <--> USER_2
end

USER_1 <--> DB_41[(pp-node 1)]:::Private2
DB_41 <--> USER_3(User 3):::User

subgraph SGU4[User 4]
DB_41 <--> USER_4(User 4):::User
DB_42 <--> USER_4
end

USER_1 <-.-> DB_PUBLIC[(Optional<br>centralized<br>public<br>node)]:::Central
USER_2 <-.-> DB_PUBLIC
CLOUD(((Cloud))):::Cloud <--> DB_31[(pp-node 1)]:::Public
CLOUD <--> DB_42[(pp-node 2)]:::Public

subgraph SGU3[User 3]
DB_31 <--> USER_3
end

DB_PUBLIC <-.-> USER_N(Other users):::User
DB_PUBLIC <-.-> USER_3
DB_PUBLIC <-.-> USER_4
DB_PUBLIC <-.-> CLOUD

linkStyle 0,1,2,3,4 stroke:lightcoral;
linkStyle 5,6,7 stroke:orange;
classDef Private1 fill:LightCoral,color:White,stroke:Gray
classDef Private2 fill:orange,color:White
classDef Public fill:#EEE,color:Black,stroke:#DDD
classDef Cloud fill:#EFE,color:#2F2,stroke:#DFD,font-size:40pt
classDef Central fill:#EEE,color:Black,stroke:#BBB,stroke-dasharray:5 5
classDef User fill:#FFF,color:#33F,stroke:CCF
style SGU1 fill:#EEF,stroke:#DDF
style SGU2 fill:#EEF,stroke:#DDF
style SGU3 fill:#EEF,stroke:#DDF
style SGU4 fill:#EEF,stroke:#DDF
```

### Repository dependencies
```mermaid
graph TB
LIB(pp-js-lib) --> NODE(pp-node)
API(pp-api) --> APP(pp-app)
APP --> MAIN(pp-main)
NODE --> MAIN
```

## Directory layout

| Name                         | Description                                   |
|------------------------------|-----------------------------------------------|
| personal/                    | Personal node packaging                       |

