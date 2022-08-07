FROM golang:1.17-bullseye as peerswap-builder

# Build peerswap
RUN git clone https://github.com/nlflint/peerswap.git /peerswap \
&& cd /peerswap \
&& make cln-release

FROM node:lts-bullseye as rest-builder

# Install core lighting REST
RUN git clone https://github.com/nlflint/c-lightning-REST /c-lightning-REST \
&& cd /c-lightning-REST \
&& git checkout plugin-domain \
&& npm install

FROM lightning:0.11.1 as final

COPY --from=rest-builder /c-lightning-REST /c-lightning-REST
COPY --from=peerswap-builder /peerswap/peerswap-plugin /peerswap/peerswap-plugin
