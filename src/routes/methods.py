from flask import request
from src import cache
from pathlib import Path
from typing import Any
import pandas as pd
import numpy as np

data_file = Path(__file__).parent / Path("../data/NCHS_-_Leading_Causes_of_Death__United_States.csv")


def health_check() -> str:
    return "pong"


def table_data() -> Any:
    query = request.args.get("filter")
    if not query:
        df = pd.read_csv(data_file)
        response = df.to_json(orient="split")
        return response
    return filter_data(query)


@cache.cached(query_string=True)
def filter_list() -> Any:
    column = request.args.get("field").lower()
    query = request.args.get("search")
    df = pd.read_csv(data_file)
    df.columns = [col.lower().replace(" ", "") for col in df.columns]
    unique_values = df.loc[:, column].unique()

    if query:
        query = query.lower()
        valid = [query == val.lower()[0: len(query)] for val in unique_values]
        unique_values = unique_values[valid]

    values = []
    for val in unique_values:
        item = {"value": val, "label": val}
        values.append(item)

    response = {"result": values}

    return response


def filter_data(query) -> Any:
    filters = query.split(",")
    df = pd.read_csv(data_file)
    init_columns = df.columns
    df.columns = [col.lower().replace(" ", "") for col in df.columns]
    valid_causes = df.loc[:, "causename"].isin(filters)
    valid_states = df.loc[:, "state"].isin(filters)
    causes = df.loc[valid_causes]
    states = df.loc[valid_states]

    if causes.size != 0:
        if states.size != 0:
            result = df.loc[valid_causes & valid_states]
        else:
            result = causes
    else:
        result = states

    result.columns = init_columns
    response = result.to_json(orient="split")
    return response
