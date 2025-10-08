import os.path
from importlib.resources import contents
import math
from flask import Flask, render_template, request, session,redirect
from flask_sqlalchemy import SQLAlchemy
from flask_mail import Mail
from datetime import datetime
import json

from werkzeug.utils import secure_filename

with open('config.json', 'r') as c:
    params = json.load(c)["params"]

# Detect if we're running on Render
on_render = os.environ.get('RENDER') is not None    

local_server = True
app = Flask(__name__)
app.secret_key = 'super-secret-key'
app.config['UPLOAD_FOLDER']= params['upload_location']
if on_render:
    # Use PostgreSQL on Render
    database_url = os.environ.get('DATABASE_URL')
    if database_url and database_url.startswith('postgres://'):
        database_url = database_url.replace('postgres://', 'postgresql://', 1)
    app.config['SQLALCHEMY_DATABASE_URI'] = database_url
else:
    # Use MySQL locally
    app.config['SQLALCHEMY_DATABASE_URI'] = params['local_uri']

app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False

db = SQLAlchemy(app)



class Contacts(db.Model):
    sno = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(80), nullable=False)
    phone_num = db.Column(db.String(20), nullable=False)
    msg = db.Column(db.String(120), nullable=False)
    date = db.Column(db.DateTime, nullable=True)
    email = db.Column(db.String(50), nullable=False)


class Posts(db.Model):
    sno = db.Column(db.Integer, primary_key=True)
    title = db.Column(db.String(80), nullable=False)
    slug = db.Column(db.String(21), nullable=False)
    content = db.Column(db.String(120), nullable=False)
    tagline = db.Column(db.String(120), nullable=False)
    date = db.Column(db.DateTime, nullable=True)
    img_file = db.Column(db.String(20), nullable=True)

class Team(db.Model):
    sno = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(80), nullable=False)
    position = db.Column(db.String(80), nullable=False)
    bio = db.Column(db.String(200), nullable=False)
    img_file = db.Column(db.String(20), nullable=True)
    email = db.Column(db.String(50), nullable=True)
    date = db.Column(db.DateTime, nullable=True, default=datetime.now)

# Initialize database tables
@app.before_first_request
def create_tables():
    db.create_all()


# for auto load template
if not on_render:
    app.jinja_env.auto_reload = True
    app.config["TEMPLATES_AUTO_RELOAD"] = True
    app.config["DEBUG"] = True


@app.route("/")
def home():
    posts = Posts.query.filter_by().all()
    last = math.ceil(len(posts)/int(params['no_of_posts']))
    #[0:params['no_of_posts']]
    page = request.args.get('page')
    if (not str(page).isnumeric() ):
        page = 1
    page = int(page)
    posts = posts[(page-1)*int(params['no_of_posts']): (page-1)*int(params['no_of_posts']) + int(params['no_of_posts']) ]
    #pagination Logic
    #first page
    if (page == 1):
        prev = "#"
        next = "/?page="+ str(page+1)
    elif (page == last):
        prev = "/?page="+ str(page-1)
        next = "#"
    else:
        prev = "/?page="+ str(page-1)
        next = "/?page="+ str(page+1)

    return render_template('index.html', params=params, posts=posts,prev=prev,next=next)


@app.route("/post/<string:post_slug>", methods=['GET'])
def post_route(post_slug):
    post = Posts.query.filter_by(slug=post_slug).first_or_404()
    return render_template('post.html', params=params, post=post)


@app.route("/about")
def about():
    return render_template('about.html', params=params)


@app.route("/dashboard", methods=['GET', 'POST'])
def dashboard():
    if ('user' in session and session['user'] == params['admin_user']):
        posts = Posts.query.all()
        team= Team.query.all()
        return render_template('dashboard.html', params=params, posts=posts, team=team)

    if request.method == "POST":
        username = request.form.get('uname')
        userpass = request.form.get('pass')
        if (username == params['admin_user'] and userpass == params['admin_password']):
            # set session variable
            session['user'] = username
            posts = Posts.query.all()
            return render_template('dashboard.html', params=params, posts=posts)

    return render_template('login.html', params=params)


@app.route("/edit/<string:sno>", methods=['GET', 'POST'])
def edit(sno):
    if ('user' in session and session['user'] == params['admin_user']):
        if request.method == "POST":
            # Get form data
            box_title = request.form.get('title')
            tline = request.form.get('tline')
            slug = request.form.get('slug')
            content = request.form.get('content')
            img_file = request.form.get('img_file')

            # EXACT SAME UPLOAD LOGIC AS UPLOADER
            uploaded_file = request.files.get('img_upload')
            if uploaded_file and uploaded_file.filename != '':
                # This is identical to what uploader does
                f = uploaded_file
                f.save(os.path.join(app.config['UPLOAD_FOLDER'], secure_filename(f.filename)))
                img_file = secure_filename(f.filename)  # Store the filename for database

            date = datetime.now()

            if sno == '0':
                post = Posts(
                    title=box_title,
                    slug=slug,
                    content=content,
                    tagline=tline,
                    img_file=img_file or 'default.jpg',
                    date=date
                )
                db.session.add(post)
                db.session.commit()
            else:
                post = Posts.query.filter_by(sno=sno).first()
                post.title = box_title
                post.slug = slug
                post.content = content
                post.tagline = tline
                if img_file:  # Only update if new file was uploaded
                    post.img_file = img_file
                post.date = date
                db.session.commit()

            return redirect('/dashboard')

        post = Posts.query.filter_by(sno=sno).first() if sno != '0' else None
        return render_template('edit.html', params=params, post=post, sno=sno)


@app.route("/delete/<string:sno>", methods=['GET', 'POST'])
def delete(sno):
    if ('user' in session and session['user'] == params['admin_user']):
        post = Posts.query.filter_by(sno=sno).first()
        db.session.delete(post)
        db.session.commit()
    return redirect('/dashboard')


@app.route("/logout")
def logout():
    session.pop('user')
    return redirect('/dashboard')

@app.route("/uploader", methods=['GET', 'POST'])
def uploader():
    if ('user' in session and session['user'] == params['admin_user']):
        if request.method == "POST":
            f= request.files['file1']
            f.save(os.path.join(app.config['UPLOAD_FOLDER'], secure_filename(f.filename)))
            return "Uploaded Successfully"


# Team page route
@app.route("/team")
def team():
    team_members = Team.query.all()
    return render_template('team.html', params=params, team_members=team_members)


# Add/Edit team member route
@app.route("/edit_team/<string:sno>", methods=['GET', 'POST'])
def edit_team(sno):
    if ('user' in session and session['user'] == params['admin_user']):
        if request.method == "POST":
            # Get form data
            name = request.form.get('name')
            position = request.form.get('position')
            bio = request.form.get('bio')
            email = request.form.get('email')
            img_file = request.form.get('img_file')

            # Handle file upload
            uploaded_file = request.files.get('img_upload')
            if uploaded_file and uploaded_file.filename != '':
                f = uploaded_file
                f.save(os.path.join(app.config['UPLOAD_FOLDER'], secure_filename(f.filename)))
                img_file = secure_filename(f.filename)

            date = datetime.now()

            if sno == '0':
                team_member = Team(
                    name=name,
                    position=position,
                    bio=bio,
                    email=email,
                    img_file=img_file or 'default_avatar.jpg',
                    date=date
                )
                db.session.add(team_member)
                db.session.commit()
                return redirect('/team')
            else:
                team_member = Team.query.filter_by(sno=sno).first()
                team_member.name = name
                team_member.position = position
                team_member.bio = bio
                team_member.email = email
                if img_file:
                    team_member.img_file = img_file
                team_member.date = date
                db.session.commit()
                return redirect('/team')

        team_member = Team.query.filter_by(sno=sno).first() if sno != '0' else None
        return render_template('edit_team.html', params=params, team_member=team_member, sno=sno)


# Delete team member route
@app.route("/delete_team/<string:sno>", methods=['GET', 'POST'])
def delete_team(sno):
    if ('user' in session and session['user'] == params['admin_user']):
        team_member = Team.query.filter_by(sno=sno).first()
        db.session.delete(team_member)
        db.session.commit()
    return redirect('/dashboard')





@app.route("/contact", methods=['GET', 'POST'])
def contact():
    if request.method == "POST":
        '''add entry to database'''
        name = request.form.get('name')
        email = request.form.get('email')
        phone = request.form.get('phone')
        message = request.form.get('message')
        entry = Contacts(name=name, email=email, phone_num=phone, date=datetime.now(), msg=message)
        db.session.add(entry)
        db.session.commit()

    return render_template('contact.html', params=params)


if __name__ == "__main__":
    app.run(debug=True)
