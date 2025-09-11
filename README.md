# pp-main
People post software assembling 

## Design
### Deployment view
```mermaid
graph LR

subgraph "User 1"
USER_1(User 1):::User <--> DB_11[(pp-node 1)]:::Private1
end

DB_11 <--> DB_21[(pp-node 1)]:::Private1
USER_1 <--> DB_21
DB_11 <--> USER_2(User 2):::User

subgraph "User 2"
DB_21 <--> USER_2
end

USER_1 <--> DB_41[(pp-node 1)]:::Private2
DB_41 <--> USER_3(User 3):::User

USER_1 <--> DB_PUBLIC[(Optional centralized public node)]:::Public
USER_2 <--> DB_PUBLIC
DB_PUBLIC <--> USER_3
CLOUD(((Cloud))):::Public <--> DB_42[(pp-node 2)]:::Public

subgraph "User 3"
USER_3
end

subgraph "User 4"
DB_41 <--> USER_4(User 4):::User
DB_42 <--> USER_4
end

DB_PUBLIC <--> USER_N(Other users):::User
DB_PUBLIC <--> CLOUD

linkStyle 0 stroke:lightcoral;
linkStyle 1 stroke:lightcoral;
linkStyle 2 stroke:lightcoral;
linkStyle 3 stroke:lightcoral;
linkStyle 4 stroke:lightcoral;
linkStyle 5 stroke:yellowgreen;
linkStyle 6 stroke:yellowgreen;
linkStyle 11 stroke:yellowgreen;
classDef Private1 fill:LightCoral,color:White,stroke:Gray
classDef Private2 fill:yellowgreen,color:White
classDef Public fill:LightGray,color:Black,stroke:Gray
classDef User fill:CadetBlue,color:white,stroke:DarkCyan
```

### Repository dependencies
```mermaid
graph TB
LIB(pp-js-lib) --> NODE(pp-node)
APP(pp-app) --> MAIN(pp-main)
NODE --> MAIN
```

## Directory layout

| Name                         | Description                                   |
|------------------------------|-----------------------------------------------|
| personal/                    | Personal node packaging                       |

