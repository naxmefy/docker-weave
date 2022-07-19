FROM alpine

WORKDIR /app
COPY weave ./weave
ENV PATH="/app:$PATH"
CMD [ "weave" ]