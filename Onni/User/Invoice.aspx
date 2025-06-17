<%@ Page Title="" Language="C#" MasterPageFile="~/User/User.Master" AutoEventWireup="true" CodeBehind="Invoice.aspx.cs" Inherits="Onni.User.Invoice" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script>
        window.onload = function () {
            var seconds = 5;
            setTimeout(function () {
                document.getElementById("<%= lblMsg.ClientID %>").style.display = "none";
           }, seconds * 1000);
        };
    </script>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <section class="breadcrumb-section set-bg" data-setbg="assets/img/breadcrumb.jpg">
        <div class="container">
            <div class="row">
                <div class="col-lg-12 text-center">
                    <div class="breadcrumb__text">
                        <h2>Чек</h2>
                    </div>
                </div>
            </div>
        </div>
    </section>
    <section class="shoping-cart spad">
        <div class="container">
            <asp:Label ID="lblMsg" runat="server" Visible="false" CssClass="alert alert-success d-block mb-3"></asp:Label>

            <asp:Repeater ID="rOrderItem" runat="server">
                <HeaderTemplate>
                    <div class="shoping__cart__table">
                        <table class="table">
                            <thead>
                                <tr>
                                    <th class="text-center">№</th>
                                    <th>Номер заказа</th>
                                    <th>Товар</th>
                                    <th class="text-center">Цена за единицу</th>
                                    <th class="text-center">Количество</th>
                                    <th class="text-center">Сумма</th>
                                </tr>
                            </thead>
                            <tbody>
                </HeaderTemplate>
                <ItemTemplate>
                    <tr>
                        <td class="text-center"><%# Eval("Srno") %></td>
                        <td><%# Eval("OrderNo") %></td>
                        <td><%# Eval("Name") %></td>
                        <td class="text-center"><%# Eval("Price") %> сом</td>
                        <td class="text-center"><%# Eval("Quantity") %></td>
                        <td class="text-center"><%# Eval("TotalPrice") %> сом</td>
                    </tr>
                </ItemTemplate>
                <FooterTemplate>
                    </tbody>
                        </table>
                    </div>
                </FooterTemplate>
            </asp:Repeater>
            <div class="row">
                <div class="col-lg-6 offset-lg-6 text-right">
                    <h5 class="mt-3 font-weight-bold">Итого: <%= ViewState["GrandTotal"] ?? "0.00" %> сом</h5>
                </div>
            </div>

            <div class="row mt-4">
                <div class="col-lg-4 offset-lg-4">
                    <asp:LinkButton ID="lbDownloadInvoice" runat="server" CssClass="primary-btn w-100 text-center" OnClick="lbDownloadInvoice_Click">
                        <i class="fa fa-file-pdf-o mr-2"></i> СКАЧАТЬ
                    </asp:LinkButton>
                </div>
            </div>
        </div>
    </section>
</asp:Content>
