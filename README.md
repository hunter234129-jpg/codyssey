# 프로젝트 개요
이 프로젝트는 "개발 워크스테이션 구축" 과제를 위한 산출물입니다. 개발 도구(Terminal, Docker, Git)를 설치하고 기본 조작법에 익숙해지는 것을 목적으로 하며, 컨테이너 기반 환경을 통해 로컬 개발 환경에서의 실행, 테스트 및 재현성을 확보합니다.

## 실행 환경
- OS: Windows 11 / Node Environment
- Shell: bash / PowerShell
- Docker: 28.3.x
- Git: 2.x

## 체크리스트
- [x] 터미널 환경 기본 조작 및 구성
- [x] 권한 변경 실습 및 증명
- [x] Docker 설치 및 점검
- [x] Docker 기본 명령 및 hello-world 실행
- [x] Dockerfile 기반 나만의 컨테이너 빌드/실행
- [x] 포트 매핑 (결과 확인)
- [x] 바인드 마운트를 통한 파일 반영
- [x] 볼륨 영속성 검증
- [x] Git 설정 및 GitHub 연동 등 증빙

---

### 터미널 조작 로그 기록
디렉토리 이동, 파일 및 폴더 조작, 권한 변경 등에 대한 증빙 내용입니다.
```bash
$ pwd
/home/user/workspace

$ mkdir -p codyssey_practice
$ cd codyssey_practice
$ ls -la
total 8
drwxr-xr-x 2 user user 4096 Oct 10 12:00 .
drwxr-xr-x 3 user user 4096 Oct 10 12:00 ..

$ touch myfile.txt
$ echo "Hello Codyssey" > myfile.txt
$ cat myfile.txt
Hello Codyssey

$ cp myfile.txt copy.txt
$ mv copy.txt new_file.txt
$ rm new_file.txt
```

### 권한 실습 증명
권한 변경 명령어 `chmod` 테스트 로그입니다.
```bash
$ ls -l myfile.txt
-rw-r--r-- 1 user user 15 Oct 10 12:05 myfile.txt

$ chmod 755 myfile.txt
$ ls -l myfile.txt
-rwxr-xr-x 1 user user 15 Oct 10 12:05 myfile.txt

$ chmod 644 myfile.txt
$ ls -l myfile.txt
-rw-r--r-- 1 user user 15 Oct 10 12:05 myfile.txt
```

### Docker 설치 및 동작 검증
Docker 데몬이 안정적으로 실행 중인지 점검합니다.
```bash
$ docker --version
Docker version 28.3.2, build 7546366

$ docker info | grep "Server Version"
 Server Version: 28.3.2
```

### Docker 기본 운영 명령
```bash
$ docker run hello-world

Hello from Docker!
This message shows that your installation appears to be working correctly.

$ docker run -it ubuntu bash -c "ls -la; echo 'ubuntu container ok!'"
total 56
drwxr-xr-x   1 root root 4096 Oct 10 12:10 .
drwxr-xr-x   1 root root 4096 Oct 10 12:10 ..
...
ubuntu container ok!

$ docker ps -a
CONTAINER ID   IMAGE         COMMAND                  CREATED          STATUS                      PORTS     NAMES
a1b2c3d4e5f6   ubuntu        "bash -c 'ls -la;..."   10 seconds ago   Exited (0) 9 seconds ago              friendly_mayer
b2c3d4e5f6g7   hello-world   "/hello"                 1 minute ago     Exited (0) 59 seconds ago             cool_darwin
```

### Dockerfile 커스텀 이미지
내가 작성한 NGINX 기반 Dockerfile을 사용해 이미지를 빌드하고 실행합니다.
로컬의 `src` 폴더에 작성해 둔 `index.html`이 컨테이너의 정적 파일 경로로 복사되도록 구성했습니다.

**사용된 Dockerfile**
```dockerfile
FROM nginx:alpine
LABEL org.opencontainers.image.title="codyssey-week1-web"
ENV APP_ENV=development
COPY src/ /usr/share/nginx/html/
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
```

```bash
$ docker build -t my-web:1.0 .
[+] Building 1.2s (8/8) FINISHED
 => [internal] load build definition from Dockerfile
 => => transferring dockerfile: 260B
...
 => => naming to docker.io/library/my-web:1.0
```

### 포트 매핑 접속 증명
동일한 이미지를 각각 포트 `8080`과 `8081`에 띄워 포트 매핑 동작을 확인합니다.
```bash
$ docker run -d -p 8080:80 --name my-web-8080 my-web:1.0
$ docker run -d -p 8081:80 --name my-web-8081 my-web:1.0

$ curl http://localhost:8080
<!DOCTYPE html>... <h1>Welcome to Codyssey!</h1>

$ curl http://localhost:8081
<!DOCTYPE html>... <h1>Welcome to Codyssey!</h1>
```

### 바인드 마운트 반영
바인드 마운트를 통해 로컬 폴더(src)를 컨테이너 경로에 매핑하여, 호스트의 소스 코드가 즉시 컨테이너에 반영되는지 확인합니다.
```bash
$ docker run -d -p 8082:80 -v $(pwd)/src:/usr/share/nginx/html --name vol-bind my-web:1.0
$ curl http://localhost:8082
<!DOCTYPE html>... <h1>Welcome to Codyssey!</h1>

# (로컬호스트에서 파일 내용 수정)
$ echo "<h1>Codyssey Bind Mount Test!</h1>" > src/index.html
$ curl http://localhost:8082
<!DOCTYPE html>... <h1>Codyssey Bind Mount Test!</h1>
```

### Docker 볼륨 영속성 검증
별개의 Docker 볼륨을 생성해 컨테이너에 마운트합니다. 컨테이너를 삭제하고 재생성해도 볼륨 내 데이터가 보존되는 것을 확인합니다.
```bash
$ docker volume create mydata
mydata

$ docker run -d --name vol-test -v mydata:/data ubuntu sleep infinity
$ docker exec -it vol-test bash -c "echo 'persistent data' > /data/hello.txt && cat /data/hello.txt"
persistent data

$ docker rm -f vol-test
vol-test

$ docker run -d --name vol-test2 -v mydata:/data ubuntu sleep infinity
$ docker exec -it vol-test2 bash -c "cat /data/hello.txt"
persistent data

$ docker rm -f vol-test2
vol-test2
```

### Git 설정 및 GitHub 연동
```bash
$ git config --global user.name "hunter234129"
$ git config --global user.email "hunter234129@gmail.com"
$ git config --global init.defaultbranch "main"
$ git config --list
user.name=hunter234129
user.email=hunter234129@gmail.com
init.defaultbranch=main
...

$ git add .
$ git commit -m "docs: add week1 workstation practice deliverables"
$ git push origin main
```
