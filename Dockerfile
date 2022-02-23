FROM python:3-slim

RUN set -eux ;\
    apt-get update ;\
    apt-get upgrade -y ;\
    apt-get install -y git python3-virtualenv python3-dev python3-cryptography python3-gevent python3-opencv x264 libx264-dev libwebp-dev ;\
    rm -rf /var/lib/apt/lists/*

RUN set -eux ;\
    git clone https://github.com/nlef/moonraker-telegram-bot.git ;\
    virtualenv -p /usr/bin/python3 --system-site-packages /venv ;\
    /venv/bin/pip install -r moonraker-telegram-bot/scripts/requirements.txt

COPY multi-config-file.patch .
RUN patch /moonraker-telegram-bot/bot/main.py multi-config-file.patch

VOLUME /config

ENTRYPOINT ["/venv/bin/python", "/moonraker-telegram-bot/bot/main.py"]
CMD ["-c", "/config"]
