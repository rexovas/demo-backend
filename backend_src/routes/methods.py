from flask import send_file, request
from backend_src import cache
from pathlib import Path
from typing import Any, Tuple
import pandas as pd
import json

# data_file = Path("data/NCHS_-_Leading_Causes_of_Death__United_States.csv")
data_file = Path(__file__).parent / Path(
    "../data/NCHS_-_Leading_Causes_of_Death__United_States.csv"
)
# data_file = Path(__file__).parent / Path('../data/nchsrows.json')


def health_check() -> str:
    print("I RAN THIS TIME YA BASTARD")
    return "pong"


# @cache.cached()
def table_data() -> Any:
    df = pd.read_csv(data_file)
    # print(len(df))
    data = df.head(100).to_json(orient="split")
    # data = df.to_json(orient="split")
    return data
    # data = df.to_json(orient="split")
    # print(data)
    # with open(data_file) as json_file:
    #     data = json.load(json_file)
    #     return data


# return send_file(data_file, attachment_filename="data.csv")


# @cache.cached(query_string=True)
def filter_list() -> Any:
    column, query = request.args.get("column"), request.args.get("search")
    df = pd.read_csv(data_file)
    df.columns = [col.lower().replace(" ", "") for col in df.columns]
    unique_values = df.loc[:, column].unique()
    if query:
        query = query.lower()
        valid = [query == val.lower()[0: len(query)] for val in unique_values]
        unique_values = unique_values[valid]

    values = []
    for val in unique_values:
        item = {"value": val.lower().replace(" ", "-"), "label": val}
        values.append(item)

    response = {"result": values}

    return response


def filter_data() -> Tuple[str]:
    return None


# def search_table_data() -> Tuple[str]:
#     return None
#
#
# def cache_search_results() -> Tuple[str]:
#     return None
#
#
# def search_cache() -> Tuple[str]:
#     return None
