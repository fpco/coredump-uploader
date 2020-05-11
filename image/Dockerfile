FROM alpine:latest
RUN apk add --no-cache inotify-tools python3 bash
RUN pip3 install awscli
RUN mkdir /cores
COPY uploader.sh /
RUN chmod a+x /uploader.sh
CMD /uploader.sh # Takes BUCKET environment value.
