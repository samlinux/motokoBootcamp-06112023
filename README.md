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
sudo dfx canister call dao addMember '("Hans", 19)'
```

```bash
sudo dfx canister call dao getMember '(principal "gyjeh-hqgck-vkesu-y32y4-zdqsy-rwycd-pmhll-5cts7-z4dec-xvac3-3ae")'
```

```bash
sudo dfx canister call dao getAllMembers
```

```bash
sudo dfx canister call dao updateMember '("Otto", 22)'
```

```bash
sudo dfx canister call dao removeMember '(principal "gyjeh-hqgck-vkesu-y32y4-zdqsy-rwycd-pmhll-5cts7-z4dec-xvac3-3ae")'
```

```bash
sudo dfx canister call dao numberOfMembers
```
