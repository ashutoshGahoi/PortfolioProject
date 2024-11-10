from flask import Flask, request, jsonify
import util

app = Flask(__name__)


# Root route for checking server status
@app.route("/", methods=["GET"])
def home():
    return "Welcome to the Home Price Prediction API!"


# Route to get available location names
@app.route("/get_location_names", methods=["GET"])
def get_location_names():
    response = jsonify({"locations": util.get_location_names()})
    response.headers.add("Access-Control-Allow-Origin", "*")
    return response


# Route for predicting home prices
@app.route("/predict_home_price", methods=["POST"])
def predict_home_price():
    data = request.get_json()  # Expecting JSON payload
    total_sqft = float(data["total_sqft"])
    location = data["location"].lower()
    bhk = int(data["bhk"])
    bath = int(data["bath"])

    # Call util function for estimated price
    estimated_price = util.get_estimated_price(location, total_sqft, bhk, bath)
    response = jsonify({"estimated_price": estimated_price})
    response.headers.add("Access-Control-Allow-Origin", "*")
    return response


if __name__ == "__main__":
    print("Starting Python Flask Server For Home Price Prediction...")
    util.load_saved_artifacts()
    app.run()
