# MotokoBootcamp 06.11.2023

Motoko Booktcamp 06.11.23 
 - https://github.com/motoko-bootcamp/dao-adventure/
 - https://www.motokobootcamp.com/

## Terminal 1
```bash
sudo dfx start
```

## Terminal 2
```bash
sudo dfx deploy
```

### Level 1
```bash
sudo dfx canister call dao getName
```

```bash
sudo dfx canister call dao addGoal '("Goal 1")'
sudo dfx canister call dao addGoal '("Goal 2")'
sudo dfx canister call dao getGoals 
```

### Level 2
```bash
sudo dfx canister call dao addMember '(record {name = "Otto"; age = 22})'
```

```bash
sudo dfx canister call dao getMember '(principal "gyjeh-hqgck-vkesu-y32y4-zdqsy-rwycd-pmhll-5cts7-z4dec-xvac3-3ae")'
```

```bash
sudo dfx canister call dao getAllMembers
```

```bash
sudo dfx canister call dao updateMember '(record {name = "Otto"; age = 22})'
```

```bash
sudo dfx canister call dao removeMember '(principal "gyjeh-hqgck-vkesu-y32y4-zdqsy-rwycd-pmhll-5cts7-z4dec-xvac3-3ae")'
```

```bash
sudo dfx canister call dao numberOfMembers
```

### Level 3
```bash
sudo dfx canister call dao mint '(principal "gyjeh-hqgck-vkesu-y32y4-zdqsy-rwycd-pmhll-5cts7-z4dec-xvac3-3ae", 100_000)'
sudo dfx canister call dao mint '(principal "ecdtt-q65ft-h7dkf-7p5zr-x522n-ogq67-wbcv2-6bd2j-vbqpv-udbzc-oqe", 250_000)'
```

```bash
sudo dfx canister call dao balanceOf '(record {owner=principal "gyjeh-hqgck-vkesu-y32y4-zdqsy-rwycd-pmhll-5cts7-z4dec-xvac3-3ae"})'
```

```bash
sudo dfx canister call dao totalSupply
```

```bash
sudo dfx canister call dao transfer '(record {owner=principal "gyjeh-hqgck-vkesu-y32y4-zdqsy-rwycd-pmhll-5cts7-z4dec-xvac3-3ae"; subaccount=null}, record {owner=principal "ecdtt-q65ft-h7dkf-7p5zr-x522n-ogq67-wbcv2-6bd2j-vbqpv-udbzc-oqe"; subaccount=null}, 5_000)'
```

### Level 4
```bash
sudo dfx canister call dao createProposal '("This is my cool proposal")'
```

```bash
sudo dfx canister call dao getProposal 1
```

``` bash
# Testsequence
sudo dfx deploy
sudo dfx canister call dao addMember '(record {name = "Otto"; age = 22})'
sudo dfx canister call dao mint '(principal "gyjeh-hqgck-vkesu-y32y4-zdqsy-rwycd-pmhll-5cts7-z4dec-xvac3-3ae", 100)'
sudo dfx canister call dao balanceOf '(record {owner=principal "gyjeh-hqgck-vkesu-y32y4-zdqsy-rwycd-pmhll-5cts7-z4dec-xvac3-3ae"})'
sudo dfx canister call dao createProposal '("This is my second proposal")'
sudo dfx canister call dao balanceOf '(record {owner=principal "gyjeh-hqgck-vkesu-y32y4-zdqsy-rwycd-pmhll-5cts7-z4dec-xvac3-3ae"})'
sudo dfx canister call dao getProposal 1
sudo dfx canister call dao get_all_proposals
sudo dfx canister call dao vote '(1, true)'



```
