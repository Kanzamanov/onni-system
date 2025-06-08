<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="OrderStatus.aspx.cs" Inherits="Onni.Admin.OrderStatus" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet" />
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
    <div class="pcoded-inner-content pt-0">
        <div class="align-align-self-end">
            <asp:Label ID="lblMsg" runat="server" Visible="false"></asp:Label>
        </div>

        <div class="main-body">
            <div class="page-wrapper">
                <div class="page-body">
                    <div class="row">
                        <div class="col-sm-12">
                            <div class="card">
                                <div class="card-header">
                                    <h4 class="sub-title">Список заказов</h4>
                                </div>
                                <div class="card-block">
                                    <div class="row">

                                        <div class="col-sm-6 col-md-8 col-lg-8">
                                            <div class="card-block table-border-style">
                                                <div class="table-responsive">
                                                    <asp:Repeater ID="rOrderStatus" runat="server" OnItemCommand="rOrderStatus_ItemCommand">
                                                        <HeaderTemplate>
                                                            <table class="table data-table-export table-hover nowrap">
                                                                <thead>
                                                                    <tr>
                                                                        <th class="table-plus">№ заказа</th>
                                                                        <th>Дата заказа</th>
                                                                        <th>Статус</th>
                                                                        <th>Наименование товара</th>
                                                                        <th>Количество</th>
                                                                        <th>Общая сумма</th>
                                                                        <th>Способ оплаты</th>
                                                                        <th class="datatable-nosort">Изменить</th>
                                                                    </tr>
                                                                </thead>
                                                                <tbody>
                                                        </HeaderTemplate>
                                                        <ItemTemplate>
                                                            <tr>
                                                                <td class="table-plus"><%# Eval("OrderNo") %></td>
                                                                <td><%# Eval("OrderDate") %></td>
                                                                <td>
                                                                    <asp:Label ID="lblStatus" runat="server"
                                                                        Text='<%# Eval("Status").ToString() == "Pending" ? "В ожидании" :
                                                                                Eval("Status").ToString() == "Dispatched" ? "Отправлен" :
                                                                                Eval("Status").ToString() == "Delivered" ? "Доставлен" :
                                                                                Eval("Status").ToString() == "Cancelled"  ? "Отменён"    :
                                                                                Eval("Status").ToString() %>'
                                                                        CssClass='<%# Eval("Status").ToString() == "Delivered" ? "badge badge-success" :
                                                                            Eval("Status").ToString() == "Cancelled" ? "badge badge-secondary" : "badge badge-warning" %>'>
                                                                    </asp:Label>
                                                                </td>
                                                                <td><%# Eval("Name") %></td>
                                                                <td><%# Eval("Quantity") %></td>
                                                                <td><%# Eval("TotalPrice") %> сом</td>
                                                                <td>
                                                                    <%# 
                                                                    Eval("PaymentMode").ToString() == "cod"  ? "Оплата при получении" :
                                                                    Eval("PaymentMode").ToString() == "card" ? "Банковская карта"     :
                                                                    Eval("PaymentMode").ToString() == "cashbox" ? "Касса"            :
                                                                    Eval("PaymentMode").ToString()            
                                                                    %>
                                                                </td>
                                                                <td>
                                                                    <asp:LinkButton ID="lnkEdit" runat="server"
                                                                        CssClass="badge badge-primary"
                                                                        ToolTip="Редактировать детали заказа"
                                                                        CommandArgument='<%# Eval("OrderItemId") %>' CommandName="edit"
                                                                        CausesValidation="false">
                                                                        <i class="fas fa-pen"></i>
                                                                    </asp:LinkButton>
                                                                </td>
                                                            </tr>
                                                        </ItemTemplate>
                                                        <FooterTemplate>
                                                            </tbody>
                                                            </table>
                                                        </FooterTemplate>
                                                    </asp:Repeater>
                                                </div>
                                            </div>
                                        </div>

                                        <div class="col-sm-6 col-md-4 col-lg-4 mobile-inputs">
                                            <asp:Panel ID="pUpdateOrderStatus" runat="server">
                                                <h4 class="sub-title">Обновление статуса заказа</h4>
                                                <div>
                                                    <div class="form-group">
                                                        <label>Выберите новый статус</label>
                                                        <asp:DropDownList ID="ddlOrderStatus" runat="server" CssClass="form-control">
                                                            <asp:ListItem Value="0">Выберите статус</asp:ListItem>
                                                            <asp:ListItem Value="Pending">В ожидании</asp:ListItem>
                                                            <asp:ListItem Value="Dispatched">Отправлен</asp:ListItem>
                                                            <asp:ListItem Value="Delivered">Доставлен</asp:ListItem>
                                                        </asp:DropDownList>
                                                        <asp:RequiredFieldValidator ID="rfvDdlOrderStatus" runat="server" ForeColor="Red"
                                                            ControlToValidate="ddlOrderStatus" ErrorMessage="Пожалуйста, выберите статус заказа"
                                                            SetFocusOnError="true" Display="Dynamic" InitialValue="0" />
                                                        <asp:HiddenField ID="hdnOrderItemId" runat="server" Value="0" />
                                                    </div>
                                                    <div class="pb-5">
                                                        <asp:Button ID="btnUpdate" runat="server" Text="Обновить" CssClass="btn btn-primary"
                                                            OnClick="btnUpdate_Click" />
                                                        &nbsp;
                                                        <asp:Button ID="btnCancel" runat="server" Text="Отмена" CssClass="btn btn-secondary"
                                                            OnClick="btnCancel_Click" />
                                                    </div>
                                                </div>
                                            </asp:Panel>
                                        </div>

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
