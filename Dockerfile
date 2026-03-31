# 베이스 이미지 활용: NGINX Alpine 버전 (용량이 작고 가벼움)
FROM nginx:alpine

# 라벨 추가
LABEL org.opencontainers.image.title="codyssey-week1-web"
LABEL org.opencontainers.image.description="Codyssey Week 1 Custom NGINX Image"
LABEL org.opencontainers.image.author="hunter234129"

# 환경변수 추가
ENV APP_ENV=development

# 정적 파일 복사: 사전에 작성된 src/ 폴더 내부의 HTML을 NGINX의 기본 서비스 경로로 복사
COPY src/ /usr/share/nginx/html/

# 포트 노출 (문서화 목적)
EXPOSE 80

# NGINX를 데몬 모드가 아닌 포어그라운드로 실행
CMD ["nginx", "-g", "daemon off;"]
