<%@ Page Language="C#" MasterPageFile="~/Admin/Admin.Master"
         AutoEventWireup="true" CodeBehind="Analytics.aspx.cs"
         Inherits="Onni.Admin.Analytics" %>

<asp:Content ID="cMain" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="container-fluid">
        <div class="row justify-content-center">
            <div class="col-12">
                <div class="card shadow-sm p-4 mt-4">

                    <!-- Заголовок -->
                    <h3 class="mb-4 text-center">
                        <i class="fas fa-chart-bar text-primary me-2"></i>Аналитика продаж
                    </h3>

                    <!-- ▼ Выбор отчёта -->
                    <div class="form-group row align-items-center">
                        <label class="col-sm-2 col-form-label text-right font-weight-bold">Тип отчёта:</label>
                        <div class="col-sm-6">
                            <asp:DropDownList ID="ddlReport" runat="server"
                                              CssClass="form-control"
                                              AutoPostBack="true"
                                              OnSelectedIndexChanged="ddlReport_SelectedIndexChanged">
                                <asp:ListItem Value="" Text="-- выберите отчёт --" />
                                <asp:ListItem Value="TOP_SELL"      Text="Топ продаваемых товаров" />
                                <asp:ListItem Value="LEASTSELL"     Text="Наименее продаваемые" />
                                <asp:ListItem Value="NEVER_SOLD"    Text="Не продавались ни разу" />
                                <asp:ListItem Value="BY_CATEGORY"   Text="Продажи по категориям" />
                                <asp:ListItem Value="BY_BRAND"      Text="Продажи по брендам" />
                                <asp:ListItem Value="REVENUE_DAY"   Text="Доход по дням" />
                                <asp:ListItem Value="REVENUE_WEEK"  Text="Доход по неделям" />
                                <asp:ListItem Value="REVENUE_MONTH" Text="Доход по месяцам" />
                                <asp:ListItem Value="TOP_CUSTOMERS" Text="Топ покупателей" />
                            </asp:DropDownList>
                        </div>
                    </div>

                    <!-- ▼ Таблица отчёта -->
                    <div class="table-responsive mt-4">
                        <asp:GridView ID="gvReport" runat="server"
                                      CssClass="table table-bordered table-hover text-center"
                                      AutoGenerateColumns="False"
                                      AllowSorting="True"
                                      AllowPaging="True"
                                      PageSize="10"
                                      EmptyDataText="Нет данных для отображения."
                                      UseAccessibleHeader="True"
                                      HeaderStyle-CssClass="thead-light">
                        </asp:GridView>
                    </div>

                    <!-- ▼ Сообщение -->
                    <asp:Label ID="lblMsg" runat="server" Visible="false"
                               CssClass="alert alert-info d-block mt-3" />
                </div>
            </div>
        </div>
    </div>
</asp:Content>
