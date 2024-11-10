import pickle
import json
import numpy as np
import pandas as pd

__locations = None
__data_columns = None
__model = None


def get_estimated_price(location, sqft, bhk, bath):
    # Convert location input to lowercase to match columns.json if it was saved in lowercase
    location = location.lower()
    try:
        # Locate the exact index for the location in the __data_columns list
        loc_index = __data_columns.index(location)
    except ValueError:
        loc_index = -1

    # Initialize an array with zeros for all data columns
    x = np.zeros(len(__data_columns))
    x[0] = sqft
    x[1] = bath
    x[2] = bhk

    # Set the location index to 1 if it exists in __data_columns
    if loc_index >= 0:
        x[loc_index] = 1

    # Convert input array `x` into a DataFrame with column names matching __data_columns for model compatibility
    x_df = pd.DataFrame([x], columns=__data_columns)

    # Make prediction and round the result
    return round(__model.predict(x_df)[0], 2)


def load_saved_artifacts():
    print("loading saved artifacts...start")
    global __data_columns
    global __locations

    # Load column names to ensure consistent feature handling
    with open(
        r"C:\Users\Admin\OneDrive\Desktop\DS P1\bangalore_housing_prediction\server\artifacts\columns.json",
        "r",
    ) as f:
        __data_columns = json.load(f)["data_columns"]
        __locations = __data_columns[
            3:
        ]  # Use all location names starting from the 4th column

    # Load the trained model
    global __model
    if __model is None:
        with open(
            r"C:\Users\Admin\OneDrive\Desktop\DS P1\bangalore_housing_prediction\server\artifacts\banglore_home_prices_model.pickle",
            "rb",
        ) as f:
            __model = pickle.load(f)
    print("loading saved artifacts...done")


def get_location_names():
    # Return location names as per the columns.json file
    return __locations


def get_data_columns():
    # Return data column names to maintain consistency
    return __data_columns


# Test the functions with consistent data
if __name__ == "__main__":
    load_saved_artifacts()
    print(get_location_names())
    print(get_estimated_price("1st phase jp nagar", 1000, 3, 3))
    print(get_estimated_price("1st phase jp nagar", 1000, 2, 2))
    print(get_estimated_price("kalhalli", 1000, 2, 2))  # Test with an unseen location
    print(get_estimated_price("ejipura", 1000, 2, 2))  # Test with another location
