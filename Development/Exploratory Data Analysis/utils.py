import os
import pandas as _pd
from pandas import concat
from matplotlib.pyplot import figure, show
from seaborn import boxplot, lineplot, countplot, distplot


def missing_values_table(data: _pd.DataFrame):
    """
    analyze missing values in dataframe
    :param data: pandas dataframe to analyze
    :return: return a pandas Dataframe of columns with missing values
    """
    # count missing values in dataframe
    mis_val = data.isnull().sum()
    # count percentage of missing values in dataframe
    mis_val_percent = 100 * data.isnull().sum() / len(data)
    # concatenate count and percentage
    mis_val_table = concat([mis_val, mis_val_percent], axis=1)
    # rename columns
    mis_val_table_ren_columns = mis_val_table.rename(
        columns={0: 'Missing Values', 1: '% of Total Values'})
    # keep only columns with missing values and sort using percentage
    mis_val_table_ren_columns = mis_val_table_ren_columns[
        mis_val_table_ren_columns.iloc[:, 1] != 0].sort_values(
        '% of Total Values', ascending=False).round(2)
    # print recap message concerning missing values
    print("Your selected dataframe has " + str(data.shape[1]) + " columns.\n" +
          "There are " + str(mis_val_table_ren_columns.shape[0]) +
          " columns that have missing values.")
    return mis_val_table_ren_columns


def modalities_table(data: _pd.DataFrame, na=False):
    """
    analyzes categorical features modalities
    :param data: dataframe to analyze
    :param na: modalities with or without null variables (False will count null value as modality)
    :return: dataframe with categorical features modalities
    """
    # initialize modalities dictionary
    mod = {}
    # loop over categorical columns
    for e in data.select_dtypes(['object']).columns:
        # count number of modalities
        mod[e] = len(data[e].value_counts(dropna=na))
    return _pd.DataFrame.from_dict(mod, orient='index', columns=['Modalities']).sort_values('Modalities')


def save_missing_values_table(data: _pd.DataFrame, name: str, null_value: str = "-",
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


def save_values_table(data: _pd.DataFrame, name: str, prob: str = 'explanation',
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


def plot_cat_dist(data: _pd.DataFrame, orient: str = "h", n: int = 10):
    """
    plot distribution of categorical features using orient as an orientation
    :param data: dataframe to analyze
    :param orient: orientation of the plot
    :param n: limit of the countplot
    """
    # loop over categorical columns
    for i, c in enumerate(data.select_dtypes(['object']).columns):
        # plot count plot
        figure(i)
        if orient == "h":  # horizontal countplot
            countplot(y=c, palette='mako', data=data, order=data[c].value_counts().iloc[:n].index)
        else:  # vertical countplot
            countplot(x=c, palette='mako', data=data, order=data[c].value_counts().iloc[:n].index)
        show()


def plot_by_date(data: _pd.DataFrame, date_col_name: str = 'Date'):
    """
    plot line plots of numerical features on date
    :param data: dataframe to analyze
    :param date_col_name: date column name
    """
    # loop over numeric features
    for i, c in enumerate(data.select_dtypes('number').columns):
        # plot line plot
        figure(i)
        figure(figsize=(10, 5))
        lineplot(x=date_col_name, y=c, data=data, palette='mako')
        show()


def distributions(data: _pd.DataFrame, num_bins: int = 10):
    """
    plot distribution of numerical features
    :param data: dataframe to analyze
    :param num_bins: number of bins
    """
    # loop over numeric features
    for i, c in enumerate(data.select_dtypes('number').columns):
        # plot distribution plot
        figure(i)
        figure(figsize=(10, 5))
        distplot(data[c], bins=num_bins, norm_hist=True)
        show()


def boxplot_by_cat(data: _pd.DataFrame, cat_col_name: str):
    """
    plot boxplot of numerical features by categories of the specified categorical column
    :param data: dataframe to analyze
    :param cat_col_name: categorical column to use
    """
    # loop over numeric features
    for i, c in enumerate(data.select_dtypes('number').columns):
        # plot boxplot
        figure(i)
        figure(figsize=(14, 7))
        boxplot(data=data, x=cat_col_name, y=c)
        show()
