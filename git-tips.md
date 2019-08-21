## 
Scenario: If you need to replace your local branch with a remote branch, run the following: 
command: git reset --hard origin/branch_name
when to use: Lets say you have commits in your local branch you don't want to push and you want to reset things to the state of the origin branch. 


## Getting the name of your current branch without using `git status`
```
"git branch | grep \* | cut -d ' ' -f2"

```

You can make this an alias 
`alias current_branch="git branch | grep \* | cut -d ' ' -f2"` and call this anytime from your terminal. 