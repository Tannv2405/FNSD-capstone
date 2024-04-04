# Use the `python:3.7` as a source image from the Amazon ECR Public Gallery
# We are not using `python:3.7.2-slim` from Dockerhub because it has put a  pull rate limit. 
FROM public.ecr.aws/sam/build-python3.9:latest as builder

# Set up an app directory for your code
COPY . /app
WORKDIR /app

# Install `pip` and needed Python packages from `requirements.txt`
RUN pip install --upgrade pip
RUN pip install -r requirements.txt


FROM python:3.9.19-slim as app
COPY --from=builder /root/.local /root/.local
COPY --from=builder /usr/app .

ENV PATH=/root/.local:$PATH
EXPOSE 80
EXPOSE 5000
CMD ["flask", "run"]