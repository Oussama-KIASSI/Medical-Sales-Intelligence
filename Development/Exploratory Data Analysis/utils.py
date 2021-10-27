import os

import pandas
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns


def missing_values_table(data: pandas.DataFrame):
    """

    :param data:
    :return:
    """
    mis_val = data.isnull().sum()
    mis_val_percent = 100 * data.isnull().sum() / len(data)
    mis_val_table = pd.concat([mis_val, mis_val_percent], axis=1)
    mis_val_table_ren_columns = mis_val_table.rename(
        columns={0: 'Missing Values', 1: '% of Total Values'})
    mis_val_table_ren_columns = mis_val_table_ren_columns[
        mis_val_table_ren_columns.iloc[:, 1] != 0].sort_values(
        '% of Total Values', ascending=False).round(2)
    print("Your selected dataframe has " + str(data.shape[1]) + " columns.\n" +
          "There are " + str(mis_val_table_ren_columns.shape[0]) +
          " columns that have missing values.")
    return mis_val_table_ren_columns


def modalities_table(data: pandas.DataFrame, na=False):
    """

    :param data:
    :param na:
    :return:
    """
    mod = {}
    for e in data.select_dtypes(['object']).columns:
        mod[e] = len(data[e].value_counts(dropna=na))
    mod_table = pd.DataFrame.from_dict(mod, orient='index', columns=['Modalities']).sort_values('Modalities')
    return mod_table


def save_missing_values_table(data: pandas.DataFrame, name: str, path: str = '..\..\Data\Problem'):
    """

    :param data:
    :param name:
    :param path:
    :return:
    """
    if not os.path.exists(path):
        os.makedirs(path)
    data[data.isnull().any(axis=1)].fillna('-').to_excel(os.path.join(path, name + '_missing_values.xlsx'))


def save_values_table(data: pandas.DataFrame, name: str, prob: str = 'explanation',
                      path: str ='..\..\Data\Problem'):
    """

    :param data:
    :param name:
    :param prob:
    :param path:
    :return:
    """
    if not os.path.exists(path):
        os.makedirs(path)
    data.to_excel(os.path.join(path, name + '_' + prob + '.xlsx'))


def plot_cat_dist_h(data: pandas.DataFrame, n: int =10):
    """

    :param data:
    :param n:
    :return:
    """
    cols = data.select_dtypes(['object']).columns
    for i, c in enumerate(cols):
        plt.figure(i)
        sns.countplot(y=c, palette='mako', data=data, order=data[c].value_counts().iloc[:n].index)
        plt.show()


def plot_cat_dist_v(data: pandas.DataFrame, n: int =10):
    """

    :param data:
    :param n:
    :return:
    """
    cols = data.select_dtypes(['object']).columns
    for i, c in enumerate(cols):
        plt.figure(i)
        sns.countplot(x=c, palette='mako', data=data, order=data[c].value_counts().iloc[:n].index)
        plt.show()


def plot_by_date(data: pandas.DataFrame, date_col_name: str = 'Date'):
    """

    :param data:
    :param date_col_name:
    :return:
    """
    cols = data.select_dtypes('number').columns
    for i, c in enumerate(cols):
        plt.figure(i)
        plt.figure(figsize=(10, 5))
        sns.lineplot(x=date_col_name, y=c, data=data, palette='mako')
        plt.show()


def distributions(data: pandas.DataFrame, num_bins: int =10):
    """

    :param data:
    :param num_bins:
    :return:
    """
    cols = data.select_dtypes('number').columns
    for i, c in enumerate(cols):
        plt.figure(i)
        plt.figure(figsize=(10, 5))
        sns.distplot(data[c], bins=num_bins, norm_hist=True)
        plt.show()


def boxplot_by_cat(data: pandas.DataFrame, cat_col_name: str):
    """

    :param data:
    :param cat_col_name:
    :return:
    """
    cols = data.select_dtypes('number').columns
    for i, c in enumerate(cols):
        plt.figure(i)
        plt.figure(figsize=(14, 7))
        sns.boxplot(data=data, x=cat_col_name, y=c)
        plt.show()
