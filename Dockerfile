# set the base image 
FROM python:3.8.10

RUN pip install --upgrade pip

COPY requirements.txt ./
RUN pip install -r requirements.txt

#COPY ./entrypoint.sh /
#RUN chmod u+x /entrypoint.sh

#add project files to the /home/hossam/travel-app-workshop folder
ADD . /home/hossam/DevOps-Challenge

#set directoty where CMD will execute 
WORKDIR /home/hossam/DevOps-Challenge

RUN python3 manage.py makemigrations --no-input
RUN python3 manage.py migrate --no-input
RUN python3 manage.py collectstatic --no-input

# give permission for nginx to read static files
RUN chown -R "$USER":www-data /static/ && chmod -R 755 /static/

# default command to execute 
CMD exec gunicorn Traveling.wsgi:application --bind 0.0.0.0:8000

#ENTRYPOINT ["/entrypoint.sh"]
#ENTRYPOINT ["sh","/entrypoint.sh"]