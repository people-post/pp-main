# pp-main
People post software assembling 

## Design
### Deployment view
```mermaid
graph LR
USER_1(User 1) <--> DB_11[(11)]:::Private1
DB_11 <--> DB_21[(21)]:::Private1
USER_1 <--> DB_21
DB_11 <--> USER_2(User 2)
DB_21 <--> USER_2
USER_1 <--> DB_41[(41)]:::Private2
DB_41 <--> USER_3(User 3)
DB_41 <--> USER_4(User 4)
USER_1 <--> DB_PUBLIC[(Public)]
USER_2 <--> DB_PUBLIC
DB_PUBLIC <--> USER_3
DB_PUBLIC <--> DB_42[(42)]
DB_42 <--> USER_4
DB_PUBLIC <--> USER_N(Other users)

linkStyle 0 stroke:lightcoral;
linkStyle 1 stroke:lightcoral;
linkStyle 2 stroke:lightcoral;
linkStyle 3 stroke:lightcoral;
linkStyle 4 stroke:lightcoral;
linkStyle 5 stroke:yellowgreen;
linkStyle 6 stroke:yellowgreen;
linkStyle 7 stroke:yellowgreen;
classDef Private1 fill:lightcoral,color:white
classDef Private2 fill:yellowgreen,color:white
```

### Repository dependencies
```mermaid
graph TB
LIB(pp-js-lib) <--> NODE(pp-node)
APP(pp-app) <--> MAIN(pp-main)
NODE <--> MAIN
```

## Directory layout

| Name                         | Description                                   |
|------------------------------|-----------------------------------------------|
| personal/                    | Personal node packaging                       |

