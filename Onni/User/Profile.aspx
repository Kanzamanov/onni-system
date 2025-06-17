<%@ Page Title="" Language="C#" MasterPageFile="~/User/User.Master" AutoEventWireup="true" CodeBehind="Profile.aspx.cs" Inherits="Onni.User.Profile" %>

<%@ Import Namespace="Onni" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script>
        $(function () {
            $('[data-toggle="tooltip"]').tooltip();
        });
    </script>

</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <div class="contact-form spad">
        <div class="container">
            <div class="heading_container">
                <div class="mb-4"></div>
                <div class="contact__form__title text-center">
                    <asp:Label ID="lblHeaderMsg" runat="server" Text="Информация о пользователе" CssClass="h2" />
                </div>
            </div>
            <div class="row justify-content-center">
                <div class="col-12">
                    <div class="card">
                        <div class="card-body">
                            <div class="card-title mb-4">
                                <div class="d-flex justify-content-start">
                                    <div class="image-container">
                                        <img src="../Images/login.png" style="width: 150px; height: 150px;" class="img-thumbnail" />

                                    </div>
                                    <div class="userData ml-3">
                                        <h2 class="d-block" style="font-size: 1.5rem; font-weight: bold">
                                            <a href="javascript:void(0);"><% Response.Write(Session["name"]); %></a>
                                        </h2>
                                        <h6 class="d-block">
                                            <a href="javascript:void(0);">
                                                <asp:Label ID="lblUsername" runat="server" ToolTip="Unique Username">@<% Response.Write(Session["username"]); %>
                                                </asp:Label>
                                            </a>
                                        </h6>
                                        <h6 class="d-block">
                                            <a href="javascript:void(0);">
                                                <asp:Label ID="lblEmail" runat="server" ToolTip="User Email">
                                                    <% Response.Write(Session["email"]); %>
                                                </asp:Label>
                                            </a>
                                        </h6>
                                        <h6 class="d-block">
                                            <a href="javascript:void(0);">
                                                <asp:Label ID="lblCreatedDate" runat="server" ToolTip="Account Created On">
                                                    <% Response.Write(Session["createdDate"]); %>
                                                </asp:Label>
                                            </a>
                                        </h6>
                                    </div>
                                </div>
                                <div class="middle pt-2">
                                    <a href="Registration.aspx?id=<% Response.Write(Session["userId"]); %>" class="btn btn-warning text-white fw-bold">
                                        <i class="fa fa-pencil text-white"></i>Редактировать
                                    </a>
                                    <asp:LinkButton ID="btnDeactivate" runat="server" CssClass="btn btn-danger" OnClick="btnDeactivate_Click"
                                        OnClientClick="return confirm('Удалить аккаунт? Ваши покупки сохранятся, но войти будет нельзя.');"><i class="fa fa-trash mr-1"></i> Удалить аккаунт
                                    </asp:LinkButton>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-12">
                                    <ul class="nav nav-tabs mb-4" id="myTab" role="tablist">
                                        <li class="nav-item">
                                            <a class="nav-link active text-info" id="basicInfo-tab" data-toggle="tab" href="#basicInfo" role="tab"
                                                aria-controls="basicInfo" aria-selected="true">
                                                <i class="fa fa-id-badge mr-2"></i>Основная Информация
                                            </a>
                                        </li>
                                        <li class="nav-item">
                                            <a class="nav-link text-info" id="connectedServices-tab" data-toggle="tab" href="#connectedServices"
                                                role="tab" aria-controls="connectedServices" aria-selected="false">
                                                <i class="fa fa-clock-o mr-2"></i>История Покупок
                                            </a>
                                        </li>
                                    </ul>

                                    <div class="tab-content ml-1" id="myTabContent">
                                        <%-- "Basic User Info Starts"--%>
                                        <div class="tab-pane fade show active" id="basicInfo" role="tabpanel" aria-labelledby="basicInfo-tab">
                                            <asp:Repeater ID="rUserProfile" runat="server">
                                                <ItemTemplate>
                                                    <div class="row">
                                                        <div class="col-sm-3 col-md-2 col-5">
                                                            <label style="font-weight: bold;">Полное Имя</label>
                                                        </div>
                                                        <div class="col-md-8 col-6">
                                                            <%# Eval("Name") %>
                                                        </div>
                                                    </div>
                                                    <hr />
                                                    <div class="row">
                                                        <div class="col-sm-3 col-md-2 col-5">
                                                            <label style="font-weight: bold;">Имя Пользователя</label>
                                                        </div>
                                                        <div class="col-md-8 col-6">
                                                            @<%# Eval("Username") %>
                                                        </div>
                                                    </div>
                                                    <hr />
                                                    <div class="row">
                                                        <div class="col-sm-3 col-md-2 col-5">
                                                            <label style="font-weight: bold;">Мобильный №</label>
                                                        </div>
                                                        <div class="col-md-8 col-6">
                                                            <%# Eval("PhoneNumber") %>
                                                        </div>
                                                    </div>
                                                    <hr />
                                                    <div class="row">
                                                        <div class="col-sm-3 col-md-2 col-5">
                                                            <label style="font-weight: bold;">Адрес электронной почты</label>
                                                        </div>
                                                        <div class="col-md-8 col-6">
                                                            <%# Eval("Email") %>
                                                        </div>
                                                    </div>
                                                    <hr />
                                                    <div class="row">
                                                        <div class="col-sm-3 col-md-2 col-5">
                                                            <label style="font-weight: bold;">Адрес</label>
                                                        </div>
                                                        <div class="col-md-8 col-6">
                                                            <%# Eval("Address") %>
                                                        </div>
                                                    </div>
                                                    <hr />

                                                </ItemTemplate>
                                            </asp:Repeater>
                                        </div>
                                        <%-- "Basic User Info Ends"--%>

                                        <%-- Order History (Ogani style) --%>
                                        <div class="tab-pane fade" id="connectedServices" role="tabpanel" aria-labelledby="connectedServices-tab">
                                            <asp:Repeater ID="rPurchaseHistory" runat="server" OnItemDataBound="rPurchaseHistory_ItemDataBound">
                                                <ItemTemplate>
                                                    <!-- Payment header -->
                                                    <div class="shoping__cart__table mb-3">
                                                        <div class="bg-light p-3 d-flex flex-column flex-md-row align-items-md-center">
                                                            <div class="flex-grow-1 mb-2 mb-md-0">
                                                                <span class="badge badge-dark mr-2"><%# Eval("SrNo") %></span>Способ оплаты:
                                                                <%# Eval("PaymentMode").ToString() == "cod" ? "Оплата при получении" : Eval("PaymentMode").ToString() == "card" ? "Банковская карта" : Eval("PaymentMode").ToString().ToUpper() %>
                                                                <%# string.IsNullOrEmpty(Eval("CardNo").ToString()) ? string.Empty : " | № карты: " + Eval("CardNo") %>
                                                            </div>
                                                            <div class="text-md-right">
                                                                <a href="Invoice.aspx?id=<%# Eval("PaymentId") %>" class="primary-btn btn-sm">
                                                                    <i class="fa fa-download mr-2"></i>Чек
                                                                </a>
                                                            </div>
                                                        </div>

                                                        <!-- Orders table -->
                                                        <asp:HiddenField ID="hdnPaymentId" runat="server" Value='<%# Eval("PaymentId") %>' />
                                                        <asp:Repeater ID="rOrders" runat="server" OnItemCommand="rOrders_ItemCommand">
                                                            <HeaderTemplate>
                                                                <table class="table mb-0">
                                                                    <thead class="thead-dark text-white">
                                                                        <tr>
                                                                            <th>Товар</th>
                                                                            <th class="text-center">Цена за ед. товара</th>
                                                                            <th class="text-center">Кол-во</th>
                                                                            <th class="text-center">Общая стоимость</th>
                                                                            <th class="text-center">№ заказа</th>
                                                                            <th class="text-center">Статус</th>
                                                                        </tr>
                                                                    </thead>
                                                                    <tbody>
                                                            </HeaderTemplate>
                                                            <ItemTemplate>
                                                                <tr>
                                                                    <td><%# Eval("Name") %></td>
                                                                    <td class="text-center"><%# Eval("Price") %> сом</td>
                                                                    <td class="text-center"><%# Eval("Quantity") %></td>
                                                                    <td class="text-center"><%# Eval("TotalPrice") %> сом</td>
                                                                    <td class="text-center"><%# Eval("OrderNo") %></td>
                                                                    <td class="text-center">
                                                                        <span class='<%# Eval("Status").ToString() == "Delivered" ? "badge badge-success" :
                                                                                Eval("Status").ToString() == "Cancelled" ? "badge badge-secondary" : "badge badge-warning" %>'>
                                                                            <%# Eval("Status").ToString() == "Pending"    ? "В обработке" :
                                                                                    Eval("Status").ToString() == "Dispatched"? "Отправлен"  :
                                                                                    Eval("Status").ToString() == "Delivered" ? "Доставлен"  :"Отменён" %>
                                                                        </span>
                                                                        <%-- кнопка видна только если можно отменить --%>
                                                                        <asp:LinkButton ID="lnkCancel" runat="server"
                                                                            CommandName="cancel"
                                                                            CommandArgument='<%# Eval("OrderItemId") %>'
                                                                            Visible='<%# Eval("Status").ToString() == "Pending" || Eval("Status").ToString() == "Dispatched" %>'
                                                                            CssClass="badge bg-danger ml-2 text-white"
                                                                            OnClientClick="return confirm('Отменить этот заказ?');"
                                                                            data-toggle="tooltip"
                                                                            data-placement="top"
                                                                            title="Отменить заказ"><i class="fa fa-times"></i>
                                                                        </asp:LinkButton>
                                                                    </td>
                                                                    <asp:HiddenField ID="hdnQty" runat="server" Value='<%# Eval("Quantity")   %>' />
                                                                    <asp:HiddenField ID="hdnProdId" runat="server" Value='<%# Eval("ProductId") %>' />

                                                                </tr>
                                                            </ItemTemplate>
                                                            <FooterTemplate>
                                                                </tbody>
                                                                </table>
                                                            </FooterTemplate>
                                                        </asp:Repeater>
                                                    </div>
                                                </ItemTemplate>
                                            </asp:Repeater>
                                        </div>
                                        <%-- Order History Ends --%>
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
