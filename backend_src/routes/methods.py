from flask import request
from backend_src import cache
from pathlib import Path
from typing import Any
import pandas as pd
import numpy as np

data_file = Path(__file__).parent / Path("../data/NCHS_-_Leading_Causes_of_Death__United_States.csv")


def health_check() -> str:
    return "pong"


@cache.cached(query_string=True)
def table_data() -> Any:
    print("TABLE DATA METHOD RAN")
    query = request.args.get("filter")
    if not query:
        df = pd.read_csv(data_file)
        response = df.to_json(orient="split")
        return response
    return filter_data(query)


@cache.cached(query_string=True)
def filter_list() -> Any:
    print("FILTER LIST METHOD RAN")
    column, query = request.args.get("column"), request.args.get("search")
    df = pd.read_csv(data_file)
    df.columns = [col.lower().replace(" ", "") for col in df.columns]
    unique_causes = df.loc[:, "causename"].unique()
    unique_states = df.loc[:, "state"].unique()
    unique_values = np.concatenate([unique_causes, unique_states])

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
    print("FILTER DATA METHOD RAN")
    filters = query.split(",")
    df = pd.read_csv(data_file)
    init_columns = df.columns
    df.columns = [col.lower().replace(" ", "") for col in df.columns]
    cause_values = df.loc[:, "causename"]
    state_values = df.loc[:, "state"]

    cause_data = []
    state_data = []
    for item in filters:
        valid_cause = [item == val for val in cause_values]
        valid_state = [item == val for val in state_values]
        cause_results = df.loc[valid_cause]
        state_results = df.loc[valid_state]
        cause_data.append(cause_results)
        state_data.append(state_results)

    cause_data = pd.concat(cause_data)
    unique_causes = cause_data.loc[:, "causename"].unique()
    state_data = pd.concat(state_data)
    unique_states = state_data.loc[:, "state"].unique()
    full_data = pd.concat([cause_data, state_data])

    cause_rows = full_data.loc[:, "causename"].isin(unique_causes)
    state_rows = full_data.loc[:, "state"].isin(unique_states)

    if unique_causes.size != 0:
        if unique_states.size != 0:
            result = full_data.loc[cause_rows & state_rows]
        else:
            result = cause_data
    else:
        result = state_data

    result.columns = init_columns
    response = result.to_json(orient="split")
    return response
