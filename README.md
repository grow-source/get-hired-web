### Passos para executar a aplicação

- **Docker build**

```bash
docker build -t nextjs-app .
```

- Executar o container

```bash
docker run -p 3000:3000 nextjs-app`
```

A aplicação estará disponível em: <http://localhost:3000>

---

### Healthcheck

- O Dockerfile inclui um healthcheck para monitorar a saúde do container. É possível verificar o status com o comando abaixo

```bash
docker inspect --format='{{json .State.Health.Status}}' container_id`
```
