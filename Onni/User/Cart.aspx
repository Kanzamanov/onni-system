<%@ Page Title="" Language="C#" MasterPageFile="~/User/User.Master" AutoEventWireup="true" CodeBehind="Cart.aspx.cs" Inherits="Onni.User.Cart" %>

<%@ Import Namespace="Onni" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script>
        window.onload = function () {
            setTimeout(function () {
                var msg = document.getElementById("<%= lblMsg.ClientID %>");
                if (msg) msg.style.display = "none";
            }, 5000);
        };
    </script>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <section class="breadcrumb-section set-bg">
        <div class="container">
            <div class="heading_container">
                <div class="cart__form__title text-right">
                    <asp:Label ID="lblMsg" runat="server" Visible="false" CssClass="alert alert-warning d-block mt-2" />
                </div>
                <div class="col-lg-12 text-center">
                    <div class="breadcrumb__text">
                        <h2>Корзина</h2>
                    </div>
                </div>
            </div>
        </div>
    </section>
    <section class="shoping-cart spad">
        <div class="container">
            <asp:Repeater ID="rCartItem" runat="server" OnItemCommand="rCartItem_ItemCommand" OnItemDataBound="rCartItem_ItemDataBound">
                <HeaderTemplate>
                    <table class="table">
                        <thead>
                            <tr>
                                <th>Название</th>
                                <th>Изображение</th>
                                <th>Цена за единицу</th>
                                <th>Количество</th>
                                <th>Итоговая цена</th>
                                <th></th>
                            </tr>
                        </thead>
                        <tbody>
                </HeaderTemplate>
                <ItemTemplate>
                    <tr>
                        <td>
                            <asp:Label ID="lblName" runat="server" Text='<%# Eval("Name") %>' />
                        </td>
                        <td>
                            <img width="60" src='<%# Utils.GetImageUrl(Eval("ImageUrl")) %>' alt="Изображение товара" />
                        </td>
                        <td>
                            <asp:Label ID="lblPrice" runat="server" Text='<%# Eval("Price") %>' />
                            сом
                            <asp:HiddenField ID="hdnProductId" runat="server" Value='<%# Eval("ProductId") %>' />
                            <asp:HiddenField ID="hdnQuantity" runat="server" Value='<%# Eval("Qty") %>' />
                            <asp:HiddenField ID="hdnPrdQuantity" runat="server" Value='<%# Eval("PrdQty") %>' />
                        </td>
                        <td>
                            <div class="product__details__option">
                                <div class="quantity">
                                    <div class="pro-qty">
                                        <asp:TextBox ID="txtQuantity" runat="server" TextMode="Number" Text='<%# Eval("Quantity") %>' />
                                        <asp:RegularExpressionValidator ID="revQuantity" runat="server"
                                            ControlToValidate="txtQuantity"
                                            ErrorMessage="*"
                                            ValidationExpression="^[1-9]\d*$"
                                            ForeColor="Red"
                                            Font-Size="Small"
                                            Display="Dynamic"
                                            SetFocusOnError="true"
                                            EnableClientScript="true" />
                                    </div>
                                </div>
                            </div>
                        </td>
                        <td>
                            <asp:Label ID="lblTotalPrice" runat="server" />
                            сом
                        </td>
                        <td>
                            <asp:LinkButton ID="lbDelete" runat="server"
                                Text="Удалить"
                                CommandName="remove"
                                CommandArgument='<%# Eval("ProductId") %>'
                                CssClass="btn btn-sm btn-danger"
                                OnClientClick="return confirm('Удалить товар из корзины?');">
                                <i class="fa fa-times"></i>
                            </asp:LinkButton>
                        </td>
                    </tr>
                </ItemTemplate>
                <FooterTemplate>
                    </tbody>
                    </table>
                    <div class="row mt-4">
                        <div class="col-lg-6 mb-3 mb-lg-0">
                            <a href="Catalog.aspx" class="primary-btn cart-btn w-100">
                                <i class="fa fa-arrow-left mr-2"></i>Продолжить покупки
                            </a>
                        </div>
                        <div class="col-lg-6 text-lg-right">
                            <asp:LinkButton ID="lbUpdateCart" runat="server" CommandName="updateCart" CssClass="primary-btn cart-btn cart-btn-right w-100">
                                <i class="fa fa-refresh mr-2"></i> Обновить корзину
                            </asp:LinkButton>
                        </div>
                    </div>
                    <div class="row mt-5">
                        <div class="col-lg-6 offset-lg-6">
                            <div class="shoping__checkout">
                                <h5>Итого</h5>
                                <ul>
                                    <li>Промежуточный итог: <span><%: Session["grandTotalPrice"] ?? 0 %> сом</span></li>
                                    <li>Итого: <span><%: Session["grandTotalPrice"] ?? 0 %> сом</span></li>
                                </ul>
                                <asp:Button ID="btnCheckout" runat="server" CssClass="primary-btn w-100" Text="Оформить заказ" OnClick="btnCheckout_Click" />
                            </div>
                        </div>
                    </div>
                </FooterTemplate>
            </asp:Repeater>
        </div>
    </section>
</asp:Content>
