FROM "homeassistant/home-assistant:latest"
LABEL maintainer="serotonie"

RUN mkdir /runwatch
COPY runwatch/run.sh /runwatch/run.sh

# Monitor HomeAssistant
COPY runwatch/200.home-assistant.enabled.sh /runwatch/200.home-assistant.enabled.sh

# Install socat
RUN apk add --no-cache socat

# Monitor socat
COPY runwatch/100.socat-zigbee.enabled.sh /runwatch/100.socat-zigbee.enabled.sh

CMD [ "bash","/runwatch/run.sh" ]
