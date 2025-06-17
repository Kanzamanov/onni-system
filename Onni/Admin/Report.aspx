<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="Report.aspx.cs" Inherits="Onni.Admin.Report" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <div class="pcoded-inner-content pt-0">

        <div class="main-body">
            <div class="page-wrapper">
                <div class="page-body">
                    <div class="row">
                        <div class="col-sm-12">
                            <div class="card">
                                <div class="card-header">
                                    <div class="container">
                                        <div class="form-row">
                                            <div class="form-group col-md-4">
                                                <label>С даты</label>
                                                <asp:RequiredFieldValidator ID="rfvFromDate" runat="server" ForeColor="Red" ErrorMessage="*"
                                                    SetFocusOnError="true" Display="Dynamic" ControlToValidate="txtFromDate">
                                                </asp:RequiredFieldValidator>
                                                <asp:TextBox ID="txtFromDate" runat="server" TextMode="Date" CssClass="form-control"></asp:TextBox>
                                            </div>
                                            <div class="form-group col-md-4">
                                                <label>По дату</label>
                                                <asp:RequiredFieldValidator ID="rfvToDate" runat="server" ForeColor="Red" ErrorMessage="*"
                                                    SetFocusOnError="true" Display="Dynamic" ControlToValidate="txtToDate">
                                                </asp:RequiredFieldValidator>
                                                <asp:TextBox ID="txtToDate" runat="server" TextMode="Date" CssClass="form-control"></asp:TextBox>
                                            </div>
                                            <div class="form-group col-md-4">
                                                <asp:Button ID="btnSearch" runat="server" Text="Показать" CssClass="btn btn-primary mt-md-4"
                                                    OnClick="btnSearch_Click" />
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div class="card-block">
                                    <div class="row">
                                        <div class="col-12 mobile-inputs">
                                            <h4 class="sub-title">Отчёт о продажах</h4>
                                            <div class="table-responsive">
                                                <asp:Repeater ID="rReport" runat="server">
                                                    <headertemplate>
                                                        <table class="table data-table-export table-hover nowrap">
                                                            <thead>
                                                                <tr>
                                                                    <th class="table-plus">№:</th>
                                                                    <th>Дата продажи:</th>
                                                                    <th>Наименование товара:</th>
                                                                    <th>Кол-во:</th>
                                                                    <th>Стоимость 1 ед:</th>
                                                                    <th>Общая стоимость:</th>
                                                                </tr>
                                                            </thead>
                                                            <tbody>
                                                    </headertemplate>

                                                    <itemtemplate>
                                                        <tr>
                                                            <td class="table-plus"><%# Eval("SrNo") %></td>
                                                            <td>
                                                                <%# ((DateTime)Eval("SaleDateTime")).ToString("dd MMMM yyyy HH:mm",System.Globalization.CultureInfo.GetCultureInfo("ru-RU")) %>
                                                            </td>
                                                            <td><%# Eval("ProductName") %></td>
                                                            <td><%# Eval("Quantity") %></td>
                                                            <td><%# Eval("UnitPrice", "{0:n2}") %>&nbsp;сом</td>
                                                            <td><%# Eval("LineTotal", "{0:n2}") %>&nbsp;сом</td>
                                                        </tr>
                                                    </itemtemplate>

                                                    <footertemplate>
                                                        </tbody>
                                                        </table>
                                                    </footertemplate>
                                                </asp:Repeater>
                                            </div>

                                        </div>
                                    </div>
                                </div>
                                <div class="row pl-4">
                                    <asp:Label ID="lblTotal" runat="server" Font-Bold="true" Font-Size="Small"></asp:Label>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    </div>

</asp:Content>
