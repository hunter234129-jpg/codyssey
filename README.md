# 프로젝트 개요
본 프로젝트는 macOS 환경에서 OrbStack을 활용하여 Docker 기반 개발 워크스테이션을 구축하는 것을 목표로 한다.
터미널, Docker, Git을 활용하여
재현 가능한 개발 환경을 구성하고, 컨테이너 기반 실행 구조를 이해한다.

## 실행 환경
OS: macOS
Shell: zsh
Docker: 28.5.2 (OrbStack)

## 체크리스트
 터미널 기본 조작

 권한 변경 실습 (파일 + 디렉토리)

 Docker 설치 및 점검

 welcome to codyssey 실행

 Docker 기본 명령

 Dockerfile 이미지 빌드

 포트 매핑 접속 확인

 바인드 마운트

 볼륨 영속성

 Git 설정 및 GitHub 연동


### 터미널 조작 로그 기록
$ pwd
/Users/user/workspace

$ mkdir codyssey_practice
$ cd codyssey_practice
```

### 권한 실습 증명
$ chmod 755 myfile.txt
$ chmod 700 test_dir
```

### Docker 동작 검증
$ docker --version
$ docker info
```

### Docker 기본 운영 명령
$ docker run 
$ docker images
$ docker ps -a
$ docker logs 
$ docker stats


### Dockerfile 커스텀 이미지
docker build -t my-web:1.0 .

**사용된 Dockerfile**
FROM nginx:alpine
LABEL org.opencontainers.image.title="codyssey-week1-web"
ENV APP_ENV=development
COPY src/ /usr/share/nginx/html/
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]


### 포트 매핑 접속 증명
docker run -d -p 8080:80 --name web1 my-web:1.0

### 바인드 마운트 반영
docker run -d -p 8082:80 \
-v $(pwd)/src:/usr/share/nginx/html \
--name bind-test my-web:1.0

echo "<h1>Bind Mount Test!</h1>" > src/index.html

### Docker 볼륨 영속성 검증
docker volume create mydata

docker run -d --name vol-test -v mydata:/data ubuntu sleep infinity

docker exec -it vol-test bash
echo "hello volume" > /data/test.txt
exit

docker rm -f vol-test

docker run -d --name vol-test2 -v mydata:/data ubuntu sleep infinity
docker exec -it vol-test2 cat /data/test.txt

