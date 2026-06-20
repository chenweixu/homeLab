
```sh
curl -i https://ollama.chenwx.top

# 查看支持的模型
curl https://ollama.chenwx.top/api/tags | jq .


# Generate a response
curl https://ollama.chenwx.top/api/generate -d '{
  "model": "qwen3.5:0.8b",
  "prompt": "中国的英文是什么?",
  "stream": false,
  "think": false
}'


curl https://ollama.chenwx.top/api/chat -d '{
  "model": "qwen3.5:0.8b",
  "messages": [{"role": "user", "content": "当前是什么模型?"}],
  "stream": false,
  "think": false
}'

```
