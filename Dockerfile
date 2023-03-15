FROM python:3.11

WORKDIR /usr/src/app

ENV DOCKERIZE_VERSION v0.6.1
RUN wget https://github.com/jwilder/dockerize/releases/download/$DOCKERIZE_VERSION/dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
    && tar -C /usr/local/bin -xzvf dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
    && rm dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
    && pip install --upgrade pip && pip install poetry==1.3.2

COPY . .

RUN poetry install

EXPOSE 9000

CMD ["poetry", "run","uvicorn", "main:app", "--host", "0.0.0.0", "--port", "9000" ]
