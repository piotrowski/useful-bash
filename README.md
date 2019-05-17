## Useful aliases

### Docker:
```bash
alias ds='docker stop $(docker ps -a -q)'
alias dsr='docker stop $(docker ps -a -q) && docker rm $(docker ps -a -q)'
```

### Kubernetes:
```bash
alias namespace='kubectl config set-context $(kubectl config current-context) --namespace'
alias kaf='kubectl apply -f'
alias kdf='kubectl delete -f'
alias kga='kubectl get all'
```

### Other:
```bash
alias pbcopy='xclip -selection clipboard'
alias pbpaste='xclip -selection clipboard -o'
```