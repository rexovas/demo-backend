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
    print(df)
    print("DID THIS RUN?")
    with open(data_file) as f:
        data = f.read()
        return df


# return send_file(data_file, attachment_filename="data.csv")


@cache.cached(query_string=True)
def filter_auto_complete() -> Tuple[str]:
    return None


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
