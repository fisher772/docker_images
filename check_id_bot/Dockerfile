# "Build" image
FROM python:3.12-slim-bookworm AS compile-image
RUN python -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"
COPY requirements.txt .
RUN pip install --no-cache-dir --upgrade pip \
 && pip install --no-cache-dir -r requirements.txt

# "Run" image
FROM gcr.io/distroless/python3
WORKDIR /app
COPY --from=compile-image /opt/venv /app/venv
ENV PYTHONPATH="/app/venv/lib/python3.12/site-packages"
COPY bot /app/bot
CMD ["-m", "bot"]
