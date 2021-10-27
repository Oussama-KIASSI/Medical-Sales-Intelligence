import os
import pandas
from pandas import concat, DataFrame
from matplotlib.pyplot import figure, show
from seaborn import boxplot, lineplot, countplot, distplot


def missing_values_table(data: pandas.DataFrame):
    """
    analyze missing data in a dataframe
    :param data: dataframe to analyze
    :return: result of analysis
    """
    mis_val = data.isnull().sum()
    mis_val_percent = 100 * data.isnull().sum() / len(data)
    mis_val_table = concat([mis_val, mis_val_percent], axis=1)
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
    analyzes categorical features modalities
    :param data: dataframe to analyze
    :param na: modalities with or without null variables (False will count null value as modality)
    :return: dataframe with categorical features modalities
    """
    mod = {}
    for e in data.select_dtypes(['object']).columns:
        mod[e] = len(data[e].value_counts(dropna=na))
    mod_table = DataFrame.from_dict(mod, orient='index', columns=['Modalities']).sort_values('Modalities')
    return mod_table


def save_missing_values_table(data: pandas.DataFrame, name: str, null_value: str = "-",
                              path: str = '..\..\Data\Problem'):
    """
    replace missing values will null and save rows with missing rows
    :param data: dataframe to use
    :param name: name of result
    :param null_value: value indicating null in dataframe
    :param path: path to save result
    """
    if not os.path.exists(path):
        os.makedirs(path)
    data[data.isnull().any(axis=1)].fillna(null_value).to_excel(os.path.join(path, name + '_missing_values.xlsx'))


def save_values_table(data: pandas.DataFrame, name: str, prob: str = 'explanation',
                      path: str = '..\..\Data\Problem'):
    """
    save problematic rows in dataframe
    :param data: dataframe to use
    :param name: name of result
    :param prob: problem of the dataframe
    :param path: path to save result
    """
    if not os.path.exists(path):
        os.makedirs(path)
    data.to_excel(os.path.join(path, name + '_' + prob + '.xlsx'))


def plot_cat_dist_h(data: pandas.DataFrame, n: int = 10):
    """
    plot distribution of categorical features horizontally
    :param data: dataframe to analyze
    :param n: limit of the countplot
    """
    cols = data.select_dtypes(['object']).columns
    for i, c in enumerate(cols):
        figure(i)
        countplot(y=c, palette='mako', data=data, order=data[c].value_counts().iloc[:n].index)
        show()


def plot_cat_dist_v(data: pandas.DataFrame, n: int = 10):
    """
    plot distribution of categorical features vertically
    :param data: dataframe to analyze
    :param n: limit of the countplot
    """
    cols = data.select_dtypes(['object']).columns
    for i, c in enumerate(cols):
        figure(i)
        countplot(x=c, palette='mako', data=data, order=data[c].value_counts().iloc[:n].index)
        show()


def plot_by_date(data: pandas.DataFrame, date_col_name: str = 'Date'):
    """
    plot line plots of numerical features on date
    :param data: dataframe to analyze
    :param date_col_name: date column name
    """
    cols = data.select_dtypes('number').columns
    for i, c in enumerate(cols):
        figure(i)
        figure(figsize=(10, 5))
        lineplot(x=date_col_name, y=c, data=data, palette='mako')
        show()


def distributions(data: pandas.DataFrame, num_bins: int = 10):
    """
    plot distribution of numerical features
    :param data: dataframe to analyze
    :param num_bins: number of bins
    """
    cols = data.select_dtypes('number').columns
    for i, c in enumerate(cols):
        figure(i)
        figure(figsize=(10, 5))
        distplot(data[c], bins=num_bins, norm_hist=True)
        show()


def boxplot_by_cat(data: pandas.DataFrame, cat_col_name: str):
    """
    plot boxplot of numerical features by categories of the specified categorical column
    :param data: dataframe to analyze
    :param cat_col_name: categorical column to use
    """
    cols = data.select_dtypes('number').columns
    for i, c in enumerate(cols):
        figure(i)
        figure(figsize=(14, 7))
        boxplot(data=data, x=cat_col_name, y=c)
        show()
