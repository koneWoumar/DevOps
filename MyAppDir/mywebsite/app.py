from flask import Flask, render_template, jsonify
import json

app = Flask(__name__)

def load_data():
    with open('data/profile.json') as f:
        return json.load(f)

@app.route('/')
def home():
    data = load_data()
    return render_template('overview.html', overview=data["overview"])

@app.route('/skills')
def skills():
    data = load_data()
    return render_template('skills.html', skills=data["skills"])

@app.route('/experiences')
def experiences():
    data = load_data()
    return render_template('experiences.html', experiences=data["experiences"])

@app.route('/education')
def education():
    data = load_data()
    return render_template('education.html', education=data["education"])

@app.route('/diplomas')
def diplomas():
    data = load_data()
    return render_template('diplomas.html', diplomas=data["diplomas"])

@app.route('/certifications')
def certifications():
    data = load_data()
    return render_template('certifications.html', certifications=data["certifications"])

@app.route('/languages')
def languages():
    data = load_data()
    return render_template('languages.html', languages=data["languages"])

@app.route('/hobby')
def hobby():
    data = load_data()
    return render_template('hobby.html', hobby=data["hobby"])

@app.route('/blog')
def blog():
    data = load_data()
    return render_template('blog.html', blog=data["blog"])

if __name__ == '__main__':
    app.run(debug=True)
