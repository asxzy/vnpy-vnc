FROM python:3.7-slim-buster

LABEL maintainer="Yi Zhang <asxzy@asxzy.net>"

RUN apt update \
	&& apt-get install --no-install-recommends -y \
	supervisor \
	x11vnc \
	fluxbox \
	xvfb \
	build-essential \
	wget \
	libglib2.0-0 \
	libxcb-icccm4 libxcb-image0 libxcb-util0 libxcb-keysyms1 libxcb-randr0 libxcb-render-util0 libxcb-xfixes0 libxcb-xinerama0 libxcb-xkb1 libxcb-shape0 \
	libxkbcommon-x11-0 \
	locales \
	ttf-wqy-zenhei \
	&& sed -i "s/# zh_CN GB2312/zh_CN GB2312/" /etc/locale.gen \
	&& locale-gen zh_CN.GB18030 \
	&& ln -s /usr/lib/x86_64-linux-gnu/libxcb-util.so.0 /usr/lib/x86_64-linux-gnu/libxcb-util.so.1 \
	&& cd /tmp \
	&& wget http://prdownloads.sourceforge.net/ta-lib/ta-lib-0.4.0-src.tar.gz \
	&& tar -xzf ta-lib-0.4.0-src.tar.gz \
	&& cd ta-lib \
	&& ./configure  --prefix=/usr \
	&& make \
	&& make install \
	&& python -m pip install --upgrade pip \
	&& python -m pip install \
	ta-lib \
	https://pip.vnpy.com/colletion/ibapi-9.76.1.tar.gz \
	wheel \
	pyqtgraph \
	qdarkstyle \
	requests \
	websocket-client \
	pymysql \
	psycopg2-binary \
	cython \
	numpy \
	pandas \
	plotly \
	deap \
	mongoengine \
	pyqt5 \
	ibapi \
	qscintilla==2.12.0 \
	peewee \
	trading-calendars \
	futu-api \
	quickfix \
	jqdatasdk \
	dash \
	qtpy \
	tzlocal \
	&& rm -rf /tmp/ta-lib* \
	&& apt purge -y build-essential wget\
	&& apt-get clean autoclean \
	&& apt-get autoremove -y \
	&& rm -rf /var/lib/{apt,dpkg,cache,log}/

# finialize
COPY copyables /

VOLUME ["/vnpy"]

EXPOSE 5900 8050

ENTRYPOINT ["/bin/bash", "/entrypoint.sh"]

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
